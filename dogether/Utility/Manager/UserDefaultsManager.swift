//
//  UserDefaultsManager.swift
//  dogether
//
//  Created by 박지은 on 2/5/25.
//

import Foundation

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let userDefaults = UserDefaults.standard
    
    private init() { }
    
    enum UserDefaultsKey: String {
        case accessToken
        case loginType
        case userFullName
        case fcmToken
        case lastAccessVersion
        case lastAccessDate
    }
    
    var accessToken: String? {
        get { userDefaults.string(forKey: UserDefaultsKey.accessToken.rawValue) }
        set { userDefaults.set(newValue, forKey: UserDefaultsKey.accessToken.rawValue) }
    }
    
    var loginType: String? {
        get { userDefaults.string(forKey: UserDefaultsKey.loginType.rawValue) }
        set { userDefaults.set(newValue, forKey: UserDefaultsKey.loginType.rawValue) }
    }
    
    var userFullName: String? {
        get { userDefaults.string(forKey: UserDefaultsKey.userFullName.rawValue) }
        set { userDefaults.set(newValue, forKey: UserDefaultsKey.userFullName.rawValue) }
    }
    
    var fcmToken: String? {
        get { userDefaults.string(forKey: UserDefaultsKey.fcmToken.rawValue) }
        set { userDefaults.set(newValue, forKey: UserDefaultsKey.fcmToken.rawValue) }
    }
    
    var lastAccessVersion: String? {
        get { userDefaults.string(forKey: UserDefaultsKey.lastAccessVersion.rawValue) }
        set { userDefaults.set(newValue, forKey: UserDefaultsKey.lastAccessVersion.rawValue) }
    }
    
    var lastAccessDate: String? {
        get { userDefaults.string(forKey: UserDefaultsKey.lastAccessDate.rawValue) }
        set { userDefaults.set(newValue, forKey: UserDefaultsKey.lastAccessDate.rawValue) }
    }
}

extension UserDefaultsManager {
    static func logout() {
        UserDefaultsManager.shared.loginType = nil
        UserDefaultsManager.shared.accessToken = nil
        UserDefaultsManager.shared.userFullName = nil
    }
}
