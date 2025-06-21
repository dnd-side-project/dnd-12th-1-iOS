//
//  WriteTodoInfo.swift
//  dogether
//
//  Created by seungyooooong on 6/8/25.
//

import Foundation

struct WriteTodoInfo {
    let content: String
    let enabled: Bool
    
    init(content: String, enabled: Bool = true) {
        self.content = content
        self.enabled = enabled
    }
}
