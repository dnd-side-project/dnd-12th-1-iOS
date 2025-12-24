//
//  ProfileViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 7/20/25.
//

import Foundation

struct ProfileViewDatas: BaseEntity {
    var name: String
    var imageUrl: String
    
    init(name: String = "", imageUrl: String = "") {
        self.name = name
        self.imageUrl = imageUrl
    }
}
