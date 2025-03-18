//
//  LoginViewModel.swift
//  dogether
//
//  Created by 박지은 on 2/11/25.
//

import Foundation
import FirebaseMessaging
import AuthenticationServices

final class OnboardingViewModel: ObservableObject {
    
    private let appleSignInDelegate = AppleSignInDelegate()

    func signInWithApple() async throws -> AppleLoginResponse {
        
        // Apple로 로그인을 시작할 메서드(버튼을 눌렀을때 호출할 메서드)
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email] // 유저로부터 알 수 있는 정보들
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        // 인증창을 보여주기 위해 로그인 정보 관련 대리자 설정
        controller.delegate = appleSignInDelegate
        controller.performRequests()
        
        // 애플 로그인 결과
        guard let result = try await appleSignInDelegate.signInResult else {
            throw NetworkError.unknown
        }
        
        let idToken = result.identityToken
        let name = result.fullUserName
        
        // 서버에 로그인 요청 보낼 데이터
        let loginRequest = AppleLoginRequest(name: name, idToken: idToken)
        
        return try await NetworkManager.shared.request(AuthRouter.appleLogin(appleLoginRequest: loginRequest))
    }
    
    // TODO: 추후 MyPageViewModel로 이동
    func withdraw() async throws {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email] // 유저로부터 알 수 있는 정보들
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        // 인증창을 보여주기 위해 로그인 정보 관련 대리자 설정
        controller.delegate = appleSignInDelegate
        controller.performRequests()
        
        // 애플 로그인 결과
        guard let result = try await appleSignInDelegate.signInResult else {
            throw NetworkError.unknown
        }
        
        let authorizationCode = result.authorizationCode
        
        let withdrawRequst = WithdrawRequest(authorizationCode: authorizationCode)
        
        try await NetworkManager.shared.request(AuthRouter.withdraw(withdrawRequest: withdrawRequst))
    }
    
    func saveNotiToken() {
        Messaging.messaging().token { token, _ in
            guard let token else { return }
            Task { @MainActor in
                let request = SaveNotiTokenRequest(token: token)
                try await NetworkManager.shared.request(NotificationsRouter.saveNotiToken(saveNotiTokenRequest: request))
                
                UserDefaultsManager.shared.fcmToken = token
            }
        }
    }
}
