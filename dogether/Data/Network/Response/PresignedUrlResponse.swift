//
//  PresignedUrlResponse.swift
//  dogether
//
//  Created by seungyooooong on 2/12/25.
//

import Foundation

struct PresignedUrlResponse: Decodable {
    let presignedUrls: [String]
}
