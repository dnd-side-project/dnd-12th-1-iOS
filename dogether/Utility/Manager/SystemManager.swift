//
//  SystemManager.swift
//  dogether
//
//  Created by seungyooooong on 2/3/25.
//

import UIKit

import ChottuLinkSDK

struct SystemManager {
    static let appleID = 6741416012
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let appStoreOpenUrlString = "itms-apps://itunes.apple.com/app/apple-store/\(SystemManager.appleID)"
    static let chottuLinkAPIKey = "c_app_O6DbHOINzQfp7Cu6a1Bmk3PYBGsyOwAj"
    
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
    static func inviteGroup(groupName: String, joinCode: String) async throws -> [Any] {
          let destinationURL =
          "https://dogether.site/invite?code=\(joinCode)"

          let builder = CLDynamicLinkBuilder(
              destinationURL: destinationURL,
              domain: "dogether-app.chottu.link"
          )
          .setIOSBehaviour(CLDynamicLinkBehaviour.app)
          .setAndroidBehaviour(CLDynamicLinkBehaviour.app)
          .build()

          LoadingManager.shared.showLoading()
          defer { LoadingManager.shared.hideLoading() }
        
          let shortURL = try await ChottuLink.createDynamicLink(for: builder)

          return ["""
          ✨ [\(groupName)]에서 당신의 참여를 기다리고 있어요

          작심삼일도 괜찮아요.
          투두 챌린지 서비스 두게더에서
          팀원들과 함께 목표 달성을 시작해보세요 💪
          
          👉 초대코드: \(joinCode) (\(shortURL!))
          """]
      }
}
