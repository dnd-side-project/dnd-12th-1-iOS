//
//  NetworkError.swift
//  dogether
//
//  Created by seungyooooong on 1/27/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case serverError(message: String)
    case decodingFailed
    case noData
    case unknown(Error)
    case dogetherError(code: DogetherCodes, message: String)
}

extension NetworkError {
    var description: String {
        switch self {
        case .invalidURL:
            return "유효하지 않은 URL입니다."
        case .badRequest:
            return "잘못된 요청입니다. 입력값을 확인해주세요."
        case .unauthorized:
            return "비인증 상태"
        case .forbidden:
            return "권한 거부"
        case .notFound:
            return "요청한 리소스를 찾을 수 없습니다."
        case .serverError(let code):
            return "서버 오류가 발생했습니다. (코드: \(code))"
        case .decodingFailed:
            return "응답 데이터를 해석할 수 없습니다."
        case .noData:
            return "데이터가 없습니다."
        case .unknown(let error):
            return "\(error.localizedDescription)"
        case .dogetherError(code: let code, message: let message):
            return "\(code.description) (\(message))"
        }
    }
}
