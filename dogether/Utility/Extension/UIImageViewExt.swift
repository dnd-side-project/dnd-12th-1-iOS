//
//  UIImageViewExt.swift
//  dogether
//
//  Created by seungyooooong on 5/12/25.
//

import UIKit

extension UIImageView {
    func loadImage(url: String?) async throws {
        guard let url, let url = URL(string: url) else { throw NSError() }
        let (data, _) = try await URLSession.shared.data(from: url)
        await MainActor.run { self.image = UIImage(data: data) }
    }
}
