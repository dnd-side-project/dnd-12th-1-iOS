//
//  LoadingViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 12/29/25.
//

import Foundation

struct LoadingViewDatas: BaseEntity {
    var isShowLoading: Bool
    
    init(isShowLoading: Bool = false) {
        self.isShowLoading = isShowLoading
    }
}
