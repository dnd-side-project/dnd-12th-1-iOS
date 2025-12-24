//
//  ExaminatePopupViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 12/9/25.
//

import Foundation

struct ExaminatePopupViewDatas: BaseEntity {
    var feedback: String
    var isFirstResponder: Bool
    
    init(
        feedback: String = "",
        isFirstResponder: Bool = false
    ) {
        self.feedback = feedback
        self.isFirstResponder = isFirstResponder
    }
}
