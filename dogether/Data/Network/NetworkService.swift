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
        guard let url = configureURL(endpoint) else {
            throw NetworkError.invalidURL
        }
        
        let request = configureRequest(url: url, endpoint)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown(NSError(domain: "", code: -1, userInfo: nil))
            }
            
            let decoded = try JSONDecoder().decode(ServerResponse<T>.self, from: data)
            
            let statusCode = httpResponse.statusCode
            switch statusCode {
            case 200:
                return decoded
            case 400:
                if let errorCode = DogetherCodes(rawValue: decoded.code) {
                    throw NetworkError.dogetherError(code: errorCode, message: decoded.message)
                } else {
                    throw NetworkError.badRequest
                }
            case 401:
                throw NetworkError.unauthorized
            case 403:
                throw NetworkError.forbidden
            case 404:
                throw NetworkError.notFound
            default:
                throw NetworkError.serverError(message: "서버 오류가 발생했습니다. (코드: \(statusCode))")
            }
        } catch let error as DecodingError {
            throw NetworkError.decodingFailed
        }  catch let error as NetworkError {
            throw error
         } catch {
            throw NetworkError.unknown(error)
        }
    }
}
