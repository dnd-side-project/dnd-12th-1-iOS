//
//  PopupDelegate.swift
//  dogether
//
//  Created by seungyooooong on 3/22/25.
//

import Foundation

protocol PopupDelegate: AnyObject {
    var completion: ((Any) -> Void)? { get }
    func hidePopup()
}
