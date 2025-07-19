//
//  DogetherCodes.swift
//  dogether
//
//  Created by seungyooooong on 2/6/25.
//

import Foundation

enum DogetherCodes: String, Decodable {
    // MARK: - Success Code
    case CGS0001 = "CGS-0001"
    case CGS0002 = "CGS-0002"
    case CGS0003 = "CGS-0003"
    case CGS0004 = "CGS-0004"
    case CGS0005 = "CGS-0005"
    case DTS0001 = "DTS-0001"
    case DTS0002 = "DTS-0002"
    case DTS0003 = "DTS-0003"
    case TCS0001 = "TCS-0001"
    case TCS0002 = "TCS-0002"
    case TCS0003 = "TCS-0003"
    case NTS0001 = "NTS-0001"
    case NTS0002 = "NTS-0002"

    // MARK: - Failure Code
    case CF0001 = "CF-0001"
    case AUF0001 = "AUF-0001"
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
    
    // MARK: - Exception Code
    case IA001 = "IA-001"

    var description: String {
        switch self {
        // MARK: - Success
        case .CGS0001: return "챌린지 그룹 생성 성공"
        case .CGS0002: return "챌린지 그룹 참여 성공"
        case .CGS0003: return "참여중인 챌린지 그룹 정보 조회 성공"
        case .CGS0004: return "참여중인 챌린지 그룹의 내 누적 활동 통계 조회 성공"
        case .CGS0005: return "참여중인 챌린지 그룹의 팀 전체 누적 활동 통계 조회 성공"
        case .DTS0001: return "데일리 투두 작성 성공"
        case .DTS0002: return "데일리 투두 수행 인증 성공"
        case .DTS0003: return "어제 작성한 데일리 투두 내용 조회 성공"
        case .TCS0001: return "데일리 투두 수행 인증 검사 성공"
        case .TCS0002: return "검사해줘야 하는 데일리 투두 인증 모두 조회 성공"
        case .TCS0003: return "검사해줘야 하는 특정 데일리 투두 인증 id 기반 상세 조회 성공"
        case .NTS0001: return "푸시 알림 토큰 저장 성공"
        case .NTS0002: return "푸시 알림 토큰 삭제 성공"

        // MARK: - Failure
        case .CF0001: return "서버 애플리케이션에 예상치 못한 문제가 발생"
        case .AUF0001: return "인증 & 인가 도메인 예기치 못한 문제 발생"
        case .MF0001: return "회원 도메인 예기치 못한 문제 발생"
        case .CGF0001: return "챌린지 그룹 도메인 예기치 못한 문제 발생"
        case .CGF0002: return "사용자가 이미 참여한 그룹" //
        case .CGF0003: return "그룹에 이미 사용자가 가득참" //
        case .CGF0004: return "이미 종료된 그룹" //
        case .CGF0005: return "존재하지 않는 그룹" //
        case .DTF0001: return "데일리 투두 도메인 예기치 못한 문제 발생" //
        case .DTCF0001: return "데일리 투두 인증 도메인 예기치 못한 문제 발생"
        case .DTHF0001: return "데일리 투두 히스토리 도메인 예기치 못한 문제 발생"
        case .MAF0001: return "사용자 활동 도메인 예기치 못한 문제 발생"
        case .NF0001: return "푸시 알림 도메인 예기치 못한 문제 발생"
        case .AIF0001: return "앱 정보 도메인 예기치 못한 문제 발생"

        // MARK: - Exception
        case .IA001: return "예기치 못한 문제 발생. 백엔드 팀에 즉시 문의"
        }
    }
}
