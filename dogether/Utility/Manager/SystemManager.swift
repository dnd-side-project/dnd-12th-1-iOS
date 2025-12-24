//
//  SystemManager.swift
//  dogether
//
//  Created by seungyooooong on 2/3/25.
//

import UIKit

struct SystemManager {
    static let appleID = 6741416012
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let appStoreOpenUrlString = "itms-apps://itunes.apple.com/app/apple-store/\(SystemManager.appleID)"
    
    func terminateApp() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { exit(0) }
    }
    
    func openAppStore() {
        guard let url = URL(string: SystemManager.appStoreOpenUrlString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            DispatchQueue.main.async { UIApplication.shared.open(url, options: [:], completionHandler: nil) }
        }
    }
    
    func openSettingApp() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            DispatchQueue.main.async { UIApplication.shared.open(url) }
        }
    }
}

extension SystemManager {
    static func inviteGroup(groupName: String, joinCode: String) -> [Any] {
        ["""
        ✨ [\(groupName)]에서 당신의 참여를 기다리고 있어요

        작심삼일도 괜찮아요.
        투두 챌린지 서비스 두게더에서
        팀원들과 함께 목표 달성을 시작해보세요 💪

        초대코드: \(joinCode) (복사해서 붙여넣기)
        https://apps.apple.com/kr/app/id\(SystemManager.appleID)
        """]
    }
}
