//
//  AppDelegate.swift
//  dogether
//
//  Created by seungyooooong on 1/20/25.
//

import UIKit

import FirebaseCore
import ChottuLinkSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate, ChottuLinkDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Override point for customization after application launch.
        
        // MARK: - about PushNotice
        UNUserNotificationCenter.current().delegate = PushNoticeManager.shared
        FirebaseApp.configure()
        application.registerForRemoteNotifications()
        
        // MARK: - ChottuLink 
        let config = CLConfiguration(
            apiKey: SystemManager.chottuLinkAPIKey,
            delegate: self
        )
        ChottuLink.initialize(config: config)
        
        return true
    }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        PushNoticeManager.shared.handleNotification(userInfo: userInfo)
        completionHandler(.newData)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
