//
//  DeepLinkManager.swift
//  dogether
//
//  Created by yujaehong on 12/27/25.
//

import Foundation

import ChottuLinkSDK

final class DeepLinkManager {
    static let shared = DeepLinkManager()

    private var pendingInviteCode: String?
    
    func resolveUrl(userActivity: NSUserActivity) async throws {
        if let url = userActivity.webpageURL {
            let resolved = try await ChottuLink.getAppLinkDataFromUrl(from: url.absoluteString)
            
            if let destinationURL = resolved.link,
               let components = URLComponents(url: destinationURL, resolvingAgainstBaseURL: false),
               let code = components.queryItems?.first(where: { $0.name == "code" })?.value {
                pendingInviteCode = code
            }
        }
    }

    func consumeInviteCode() -> String? {
        defer { pendingInviteCode = nil }
        return pendingInviteCode
    }
}
