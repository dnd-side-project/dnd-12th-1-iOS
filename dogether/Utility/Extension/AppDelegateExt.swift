//
//  AppDelegateExt.swift
//  dogether
//
//  Created by seungyooooong on 2/16/25.
//

import UIKit

import FirebaseMessaging

extension AppDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // TODO: 추후 에러 핸들링 방법 논의하고 구현
    }
}
