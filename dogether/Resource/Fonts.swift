//
//  Fonts.swift
//  dogether
//
//  Created by seungyooooong on 2/6/25.
//

import UIKit

enum Fonts {
    static func black(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Black", size: size) ?? UIFont.systemFont(ofSize: size, weight: .black)
    }
    static func bold(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Bold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
    }
    static func extraBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-ExtraBold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .heavy)
    }
    static func extraLight(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-ExtraLight", size: size) ?? UIFont.systemFont(ofSize: size, weight: .ultraLight)
    }
    static func light(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Light", size: size) ?? UIFont.systemFont(ofSize: size, weight: .light)
    }
    static func medium(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Mideum", size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium)
    }
    static func regular(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Regular", size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
    }
    static func semiBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-SemiBold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    static func thin(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Thin", size: size) ?? UIFont.systemFont(ofSize: size, weight: .thin)
    }
    
    static let emphasis1B = Fonts.bold(size: 36)
    static let emphasis2B = Fonts.bold(size: 28)
    static let head1B = Fonts.bold(size: 24)
    static let head2B = Fonts.bold(size: 18)
    static let body1B = Fonts.bold(size: 16)
    
    static let body1S = Fonts.semiBold(size: 16)
    static let body2S = Fonts.semiBold(size: 14)
    static let smallS = Fonts.semiBold(size: 12)
    
    static let head1R = Fonts.regular(size: 24)
    static let body1R = Fonts.regular(size: 16)
    static let body2R = Fonts.regular(size: 14)
    static let smallR = Fonts.regular(size: 12)
    
    static func getAttributes(for font: UIFont, textAlignment: NSTextAlignment = .center) -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineHeightMultiple = getLineHeight(for: font) / font.lineHeight
        
        return [
            .font: font,
            .paragraphStyle: paragraphStyle
        ]
    }
    
    private static func getLineHeight(for font: UIFont) -> CGFloat {
        switch font {
        case Fonts.emphasis1B:
            return 100
        case Fonts.emphasis2B, Fonts.head1B, Fonts.head1R:
            return 36
        case Fonts.head2B:
            return 28
        case Fonts.body1B, Fonts.body1S, Fonts.body1R:
            return 25
        case Fonts.body2S, Fonts.body2R:
            return 21
        case Fonts.smallS, Fonts.smallR:
            return 18
        default:
            return 0
        }
    }
}
