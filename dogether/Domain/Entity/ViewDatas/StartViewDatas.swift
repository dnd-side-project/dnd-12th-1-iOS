//
//  StartViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 8/19/25.
//

struct StartViewDatas: BaseEntity {
    let isFirstGroup: Bool
    
    init(isFirstGroup: Bool = true) {
        self.isFirstGroup = isFirstGroup
    }
}
