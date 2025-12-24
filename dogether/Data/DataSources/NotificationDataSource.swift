//
//  NotificationDataSource.swift
//  dogether
//
//  Created by seungyooooong on 3/25/25.
//

import Foundation

final class NotificationDataSource {
    static let shared = NotificationDataSource()
    
    private init() { }
    
    func saveNotiToken(saveNotiTokenRequest: SaveNotiTokenRequest) async throws {
        try await NetworkManager.shared.request(NotificationsRouter.saveNotiToken(saveNotiTokenRequest: saveNotiTokenRequest))
    }
}
