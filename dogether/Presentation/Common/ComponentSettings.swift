//
//  ComponentSettings.swift
//  dogether
//
//  Created by Jae hyung Kim on 3/7/25.
//

import UIKit.UIGeometry

protocol ComponentSettings {}

extension ComponentSettings where Self: AnyObject {
    
    /// Init 이후 객체를 수정하여 재 반환합니다.
    ///
    ///     let lable = UILabel()
    ///      .setOf {
    ///         $0.text = "TEXT"
    ///      }
    @inlinable
    func setOf(_ setiings: (Self) throws -> Void) rethrows -> Self {
        try setiings(self)
        return self
    }
}

extension NSObject: ComponentSettings {}
extension JSONDecoder: ComponentSettings {}
extension JSONEncoder: ComponentSettings {}
