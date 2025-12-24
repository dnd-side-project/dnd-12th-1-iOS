//
//  GroupJoinViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 11/19/25.
//

import Foundation

struct GroupJoinViewDatas: BaseEntity {
    var code: String
    var keyboardHeight: CGFloat
    var isFirstResponder: Bool
    
    init(
        code: String = "",
        keyboardHeight: CGFloat = 0,
        isFirstResponder: Bool = false
    ) {
        self.code = code
        self.keyboardHeight = keyboardHeight
        self.isFirstResponder = isFirstResponder
    }
}
