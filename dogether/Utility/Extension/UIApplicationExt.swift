//
//  UIApplicationExt.swift
//  dogether
//
//  Created by seungyooooong on 8/29/25.
//

import UIKit

extension UIApplication {
    static var safeAreaOffset: UIEdgeInsets {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first  else { return UIEdgeInsets() }
        return window.safeAreaInsets
    }
}
