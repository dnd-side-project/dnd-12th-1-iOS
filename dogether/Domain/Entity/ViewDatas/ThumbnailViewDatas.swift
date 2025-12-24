//
//  ThumbnailViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 10/21/25.
//

import Foundation

struct ThumbnailViewDatas: BaseEntity {
    var imageUrl: String?
    var thumbnailStatus: ThumbnailStatus
    var isHighlighted: Bool
    
    init(imageUrl: String? = nil, thumbnailStatus: ThumbnailStatus = .yet, isHighlighted: Bool = false) {
        self.imageUrl = imageUrl
        self.thumbnailStatus = thumbnailStatus
        self.isHighlighted = isHighlighted
    }
}
