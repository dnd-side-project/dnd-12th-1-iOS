//
//  AuthUseCase.swift
//  dogether
//
//  Created by seungyooooong on 3/25/25.
//

import Foundation

import AuthenticationServices
import FirebaseMessaging

final class AuthUseCase: NSObject {
    private let repository: AuthProtocol
    
    private var continuation: CheckedContinuation<(idToken: String, name: String?, authorizationCode: String), Error>?
    
    var userInfo: (idToken: String, name: String?, authorizationCode: String)? {
        get async throws {
            return try await withCheckedThrowingContinuation { continuation in
                self.continuation = continuation
            }
        }
    }
    
    init(repository: AuthProtocol) {
        self.repository = repository
    }
}

extension AuthUseCase: ASAuthorizationControllerDelegate {
    /// apple server에 login 요청을 보내는 함수입니다.
    ///
    /// 기본적으로 fullName을 요청합니다.
    func appleLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let fullName = appleIDCredential.fullName,
                  let idTokenData = appleIDCredential.identityToken,
                  let idToken = String(data: idTokenData, encoding: .utf8),
                  let authorizationCodeData = appleIDCredential.authorizationCode,
                  let authorizationCode = String(data: authorizationCodeData, encoding: .utf8) else {
                continuation?.resume(throwing: NetworkError.unauthorized) // fix me
                return
            }
            
            if fullName.familyName == nil && fullName.givenName == nil {
                continuation?.resume(returning: (idToken, nil, authorizationCode))
            } else {    // MARK: familyName, givenName 둘 중 하나라도 값이 있는 경우 nil인 쪽을 공백으로 수정 후 진행
                let name = (fullName.familyName ?? "") + (fullName.givenName ?? "")
                continuation?.resume(returning: (idToken, name, authorizationCode))
            }
        } else {
            // FIXME: 추후 iCloud 키체인 로그인 케이스 추가
            continuation?.resume(throwing: NetworkError.unauthorized) // fix me
        }
    }
}

extension AuthUseCase {
    func login(domain: LoginDomains) async throws {
        switch domain {
        case .apple:
            guard let userInfo = try await userInfo else { return }
            let appleLoginRequest = AppleLoginRequest(name: userInfo.name, idToken: userInfo.idToken)
            let response: AppleLoginResponse = try await repository.appleLogin(appleLoginRequest: appleLoginRequest)
            try await setUserDefaults(userFullName: response.name, accessToken: response.accessToken)
        }
    }
    
    func setUserDefaults(userFullName: String, accessToken: String) async throws {
        UserDefaultsManager.shared.userFullName = userFullName
        UserDefaultsManager.shared.accessToken = accessToken
        
        let token = try await Messaging.messaging().token()
        let saveNotiTokenRequest = SaveNotiTokenRequest(token: token)
        try await repository.saveNotiToken(saveNotiTokenRequest: saveNotiTokenRequest)
        
        // FIXME: code NTS-0001 case handling
        UserDefaultsManager.shared.fcmToken = token
    }
}

extension AuthUseCase {
    func withdraw() async throws {
        guard let userInfo = try await userInfo else { return }
        let withdrawRequest = WithdrawRequest(authorizationCode: userInfo.authorizationCode)
        try await repository.withdraw(withdrawRequest: withdrawRequest)
    }
}
