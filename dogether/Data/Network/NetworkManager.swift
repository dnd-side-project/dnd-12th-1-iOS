//
//  NetworkManager.swift
//  dogether
//
//  Created by seungyooooong on 1/27/25.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private init() { }
    
    weak var coordinator: NavigationCoordinator?
    
    func request<T: Decodable>(_ endpoint: NetworkEndpoint) async throws -> T {
        LoadingManager.shared.showLoading()
        defer { LoadingManager.shared.hideLoading() }
        
        do {
            let response: ServerResponse<T> = try await NetworkService.shared.request(endpoint)
            
            if T.self == EmptyData.self { return EmptyData() as! T }
            
            guard let data = response.data else {
                if let dogetherCode = DogetherCodes(rawValue: response.code) {
                    throw NetworkError.dogetherError(code: dogetherCode, message: response.message)
                } else { throw NetworkError.unknown }
            }
            
            return data
        } catch {
            if checkCommonError(error) {
                LoadingManager.shared.hideLoading()
                let data: T = try await handleCommonError(endpoint)
                LoadingManager.shared.showLoading()
                return data
            } else {
                throw handleDetailError(error)
            }
        }
    }
    
    func request(_ endpoint: NetworkEndpoint) async throws -> Void {
        let _: EmptyData = try await request(endpoint)
    }
}

// MARK: - handle error
extension NetworkManager {
    private func checkCommonError(_ error: Error) -> Bool {
        guard let error = error as? NetworkError, case let .dogetherError(code, _) = error else { return true }
        return !(code == .ATF0002 || code == .ATF0003 ||
                 code == .CGF0002 || code == .CGF0003 || code == .CGF0004 || code == .CGF0005)
    }
    
    private func handleCommonError<T: Decodable>(_ endpoint: NetworkEndpoint) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            coordinator?.showErrorView { [weak self] in
                guard let self else { return }
                Task {
                    do {
                        let result: T = try await self.request(endpoint)
                        continuation.resume(returning: result)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    private func handleDetailError(_ error: Error) -> NetworkError {
        if let error = error as? NetworkError {
            if case let .dogetherError(code, _) = error, code == .ATF0003 {
                coordinator?.showPopup(type: .alert, alertType: .needLogout) { [weak self] _ in
                    guard let self else { return }
                    UserDefaultsManager.logout()
                    coordinator?.setNavigationController(OnboardingViewController())
                }
            }
            return error
        } else { return NetworkError.unknown }
    }
}
