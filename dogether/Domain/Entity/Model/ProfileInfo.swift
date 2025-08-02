//
//  ProfileInfo.swift
//  dogether
//
//  Created by seungyooooong on 7/20/25.
//

import Foundation

struct ProfileInfo {
    let name: String?
    let imageUrl: String?
    
    init(name: String? = nil, imageUrl: String? = nil) {
        self.name = name
        self.imageUrl = imageUrl
    }
}
