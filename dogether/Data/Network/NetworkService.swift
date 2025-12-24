//
//  NetworkService.swift
//  dogether
//
//  Created by seungyooooong on 1/27/25.
//

import Foundation

class NetworkService {
    private let serverURL: URL?
    
    // MARK: 배포마다 releaseMode 수정 (추후 자동화)
    static let shared = NetworkService(releaseMode: .prod)
    private init (releaseMode: ReleaseModes) {
        self.serverURL = URL(string: releaseMode.urlString)
    }

    private func configureURL(_ endpoint: NetworkEndpoint) -> URL? {
        guard let baseURL = serverURL else { return nil }
        let url = baseURL.appendingPathComponent(endpoint.path)
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return nil }
        components.queryItems = endpoint.parameters
        
        return components.url
    }
    
    private func configureRequest(url: URL, _ endpoint: NetworkEndpoint) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        if let header = endpoint.header {
            for (key,value) in header {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let body = endpoint.body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        
        return request
    }
    
    func request<T: Decodable>(_ endpoint: NetworkEndpoint) async throws -> ServerResponse<T> {
        guard let url = configureURL(endpoint) else { throw NetworkError.invalidURL }
        
        let request = configureRequest(url: url, endpoint)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(ServerResponse<T>.self, from: data)
        return decoded
    }
}
