//
//  GroupJoinViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 11/19/25.
//

import Foundation

struct GroupJoinViewDatas: BaseEntity {
    var code: String
    var status: GroupJoinStatus // FIXME: 추후 삭제
    var keyboardHeight: CGFloat
    var isFirstResponder: Bool
    
    init(
        code: String = "",
        status: GroupJoinStatus = .normal,
        keyboardHeight: CGFloat = 0,
        isFirstResponder: Bool = false
    ) {
        self.code = code
        self.status = status
        self.keyboardHeight = keyboardHeight
        self.isFirstResponder = isFirstResponder
    }
}
