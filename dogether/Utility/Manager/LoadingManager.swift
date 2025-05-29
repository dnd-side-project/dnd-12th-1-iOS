//
//  LoadingManager.swift
//  dogether
//
//  Created by seungyooooong on 5/19/25.
//

import UIKit

final class LoadingManager {
    static let shared = LoadingManager()
    
    private(set) var loadingWindow: UIWindow? = nil
    private(set) var loadingCount: Int = 0
    
    private init() { }
    
    func showLoading() {
        loadingCount += 1
        
        if loadingWindow == nil {
            Task { @MainActor [weak self] in
                guard let self, let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                let window = UIWindow(windowScene: windowScene)
                let loadingViewController = LoadingViewController()
                
                window.frame = UIScreen.main.bounds
                window.rootViewController = loadingViewController
                window.windowLevel = .alert + 99
                window.makeKeyAndVisible()
                
                loadingWindow = window
            }
        }
    }
    
    func hideLoading() {
        loadingCount -= 1
        
        if loadingCount <= 0 {
            Task { @MainActor [weak self] in
                guard let self else { return }
                loadingWindow?.isHidden = true
                loadingWindow = nil
            }
        }
    }
}
