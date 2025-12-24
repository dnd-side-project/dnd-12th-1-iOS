//
//  ServerResponse.swift
//  dogether
//
//  Created by seungyooooong on 1/27/25.
//

import Foundation

struct ServerResponse<T: Decodable>: Decodable {
    let code: String
    let message: String
    let data: T?
}

struct EmptyData: Decodable { }
