//
//  NetworkError.swift
//  dogether
//
//  Created by seungyooooong on 1/27/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case serverError(message: String)
    case parse
    case noData
    case sslError(URLError)
    case connectionFailed(URLError)
    case unknown
    case dogetherError(code: DogetherCodes, message: String)
}

extension NetworkError {
    var description: String {
        switch self {
        case .invalidURL: return "유효하지 않은 URL입니다."
        case .serverError(let code): return "서버 오류가 발생했습니다. (코드: \(code))"
        case .parse: return "응답 데이터를 해석할 수 없습니다."
        case .noData: return "데이터가 없습니다."
        case .sslError(let error): return "보안 연결 실패: \(error.localizedDescription)"
        case .connectionFailed(let error): return "네트워크 연결이 불안정합니다. \(error.localizedDescription)"
        case .unknown: return "알 수 없는 오류가 발생했습니다."
        case .dogetherError(code: let code, message: let message): return "\(code.description) (\(message))"
        }
    }
}

// MARK: - DogetherCodes
enum DogetherCodes: String, Decodable {
    case CF0001 = "CF-0001"
    case ATF0001 = "ATF-0001"
    case ATF0002 = "ATF-0002"
    case ATF0003 = "ATF-0003"
    case MF0001 = "MF-0001"
    case CGF0001 = "CGF-0001"
    case CGF0002 = "CGF-0002"
    case CGF0003 = "CGF-0003"
    case CGF0004 = "CGF-0004"
    case CGF0005 = "CGF-0005"
    case DTF0001 = "DTF-0001"
    case DTCF0001 = "DTCF-0001"
    case DTHF0001 = "DTHF-0001"
    case MAF0001 = "MAF-0001"
    case NF0001 = "NF-0001"
    case AIF0001 = "AIF-0001"
}

extension DogetherCodes {
    var description: String {
        switch self {
        case .CF0001: return "서버 애플리케이션에 예기치 못한 문제 발생"
        case .ATF0001: return "인증 & 인가 기능에 예기치 못한 문제 발생"
        case .ATF0002: return "애플 로그인 리보크 작업 필요"
        case .ATF0003: return "유효하지 않은 JWT"
        case .MF0001: return "회원 기능에 예외 발생"
        case .CGF0001: return "챌린지 그룹 기능에 예기치 못한 문제 발생"
        case .CGF0002: return "사용자가 이미 참여한 그룹에 참여 시도"
        case .CGF0003: return "사용자가 이미 인원이 꽉찬 그룹에 참여 시도"
        case .CGF0004: return "사용자가 이미 종료된 그룹에 참여 시도"
        case .CGF0005: return "사용자가 존재하지 않는 그룹에 참여 시도"
        case .DTF0001: return "데일리 투두 기능에 예기치 못한 문제 발생"
        case .DTCF0001: return "데일리 투두 인증 기능에 예기치 못한 문제 발생"
        case .DTHF0001: return "데일리 투두 히스토리 기능에 예기치 못한 문제 발생"
        case .MAF0001: return "사용자 활동 기능에 예기치 못한 문제 발생"
        case .NF0001: return "알림 기능에 예기치 못한 문제 발생"
        case .AIF0001: return "앱 정보 기능에 예기치 못한 문제 발생"
        }
    }
}
