//
//  DIManager.swift
//  dogether
//
//  Created by seungyooooong on 3/25/25.
//

import Foundation

final class DIManager {
    static let shared = DIManager()
    
    private init() { }
    
    enum BuildModes {
        case debug
        case live
    }
    
    private let defaultBuildMode: BuildModes = .live
}

extension DIManager {
    func getAppInfoRepository(buildMode: BuildModes? = nil) -> AppInfoProtocol {
        switch buildMode ?? defaultBuildMode {
        case .debug:
            return AppInfoRepositoryTest()
        case .live:
            return AppInfoRepository()
        }
    }
    
    func getAuthRepository(buildMode: BuildModes? = nil) -> AuthProtocol {
        switch buildMode ?? defaultBuildMode {
        case .debug:
            return AuthRepositoryTest()
        case .live:
            return AuthRepository()
        }
    }
    
    func getGroupRepository(buildMode: BuildModes? = nil) -> GroupProtocol {
        switch buildMode ?? defaultBuildMode {
        case .debug:
            return GroupRepositoryTest()
        case .live:
            return GroupRepository()
        }
    }
    
    func getChallengeGroupsRepository(buildMode: BuildModes? = nil) -> ChallengeGroupsProtocol {
        switch buildMode ?? defaultBuildMode {
        case .debug:
            return ChallengeGroupsRepositoryTest()
        case .live:
            return ChallengeGroupsRepository()
        }
    }
    
    func getTodoCertificationsRepository(buildMode: BuildModes? = nil) -> TodoCertificationsProtocol {
        switch buildMode ?? defaultBuildMode {
        case .debug:
            return TodoCertificationsRepositoryTest()
        case .live:
            return TodoCertificationsRepository()
        }
    }
    
    func getUserRepository(buildMode: BuildModes? = nil) -> UserProtocol {
        switch buildMode ?? defaultBuildMode {
        case .debug:
            return UserRepositoryTest()
        case .live:
            return UserRepository()
        }
    }
}
