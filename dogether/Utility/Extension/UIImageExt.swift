//
//  UIImageExt.swift
//  dogether
//
//  Created by seungyooooong on 2/20/25.
//

import UIKit

extension UIImage {
    func setDefaultImagePadding() -> UIImage {
        self.imageWithPadding(
            insets: UIEdgeInsets(
                top: 41 * 4,
                left: 62 * 4,
                bottom: 83 * 4,
                right: 62 * 4
            ),
            backgroundColor: .grey800
        )
    }
}

extension UIImage {
    func compressImage(maxSize: CGFloat = 1024, compressionQuality: CGFloat = 0.7) -> UIImage? {
        let newWidth = self.size.width > self.size.height ? maxSize : maxSize * self.size.width / self.size.height
        let newHeight = self.size.width > self.size.height ? maxSize * self.size.height / self.size.width : maxSize
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let data = resizedImage?.jpegData(compressionQuality: compressionQuality) else { return nil }
        return UIImage(data: data)
    }
    
    func imageWithPadding(insets: UIEdgeInsets, backgroundColor: UIColor = .clear) -> UIImage {
        let newSize = CGSize(width: self.size.width + insets.left + insets.right,
                             height: self.size.height + insets.top + insets.bottom)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        backgroundColor.setFill()
        UIRectFill(CGRect(origin: .zero, size: newSize))

        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let paddedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return paddedImage ?? self
    }
}
