//
//  WriteTodoEntity.swift
//  dogether
//
//  Created by seungyooooong on 10/3/25.
//

import Foundation

struct WriteTodoEntity: BaseEntity {
    let content: String
    let enabled: Bool
    
    init(content: String, enabled: Bool = true) {
        self.content = content
        self.enabled = enabled
    }
}
