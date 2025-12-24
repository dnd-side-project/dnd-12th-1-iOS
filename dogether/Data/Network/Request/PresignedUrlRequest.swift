//
//  PresignedUrlRequest.swift
//  dogether
//
//  Created by seungyooooong on 2/12/25.
//

import Foundation

struct PresignedUrlRequest: Encodable {
    let dailyTodoId: Int
    let uploadFileTypes: [String]
    
    init(dailyTodoId: Int, uploadFileTypes: [String]) {
        self.dailyTodoId = dailyTodoId
        self.uploadFileTypes = uploadFileTypes
    }
}
