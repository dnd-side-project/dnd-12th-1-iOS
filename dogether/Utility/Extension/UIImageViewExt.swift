//
//  UIImageViewExt.swift
//  dogether
//
//  Created by seungyooooong on 5/12/25.
//

import UIKit
import Kingfisher

extension UIImageView {
    func loadImage(url: String?, successAction: (() -> Void)? = nil) {
        guard let url, let url = URL(string: url) else { return }
        self.kf.setImage(with: url) { result in
            switch result {
            case .success(_):
                successAction?()
            default:
                return
            }
        }
    }
}
