//
//  BottomSheetViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 9/15/25.
//

import Foundation

struct BottomSheetViewDatas: BaseEntity {
    var isShowSheet: Bool
    
    init(isShowSheet: Bool = false) {
        self.isShowSheet = isShowSheet
    }
}
