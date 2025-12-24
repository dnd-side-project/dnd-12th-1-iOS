//
//  AlertPopupViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 12/7/25.
//

import Foundation

struct AlertPopupViewDatas: BaseEntity {
    let type: AlertTypes?
    
    init(type: AlertTypes?) {
        self.type = type
    }
}
