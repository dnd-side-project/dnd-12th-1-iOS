//
//  CertificateViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 12/9/25.
//

import Foundation

struct CertificateViewDatas: BaseEntity {
    var todo: TodoEntity
    var keyboardHeight: CGFloat
    var isFirstResponder: Bool
    
    init(
        todo: TodoEntity = TodoEntity(id: 0, content: "", status: .waitCertification),
        keyboardHeight: CGFloat = 0,
        isFirstResponder: Bool = false
    ) {
        self.todo = todo
        self.keyboardHeight = keyboardHeight
        self.isFirstResponder = isFirstResponder
    }
}
