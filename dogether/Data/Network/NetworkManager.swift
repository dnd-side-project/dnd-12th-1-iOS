//
//  NetworkManager.swift
//  dogether
//
//  Created by seungyooooong on 1/27/25.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() { }
    
    func request<T: Decodable>(_ endpoint: NetworkEndpoint) async throws -> T {
        LoadingManager.shared.showLoading()
        defer { LoadingManager.shared.hideLoading() }
        
        do {
            let response: ServerResponse<T> = try await NetworkService.shared.request(endpoint)
            
            if response.code == "99" {
                throw NetworkError.server
            } else if let data = response.data {
                return data
            } else {
                throw NetworkError.parse
            }
        } catch {
           throw mapError(error)
        }
    }
    
    func request(_ endpoint: NetworkEndpoint) async throws -> Void {
        LoadingManager.shared.showLoading()
        defer { LoadingManager.shared.hideLoading() }
        
        do {
            let response: ServerResponse<EmptyData> = try await NetworkService.shared.request(endpoint)
            
            if response.code == "99" {
                throw NetworkError.server
            }
        } catch {
            throw mapError(error)
        }
    }
    
    private func mapError(_ error: Error) -> NetworkError {
        if let networkError = error as? NetworkError {
            return networkError
        } else {
            return NetworkError.unknown
        }
    }
}
