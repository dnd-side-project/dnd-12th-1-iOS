//
//  LoginResponse.swift
//  dogether
//
//  Created by seungyooooong on 2/4/25.
//

import Foundation

struct LoginResponse: Decodable {
    let name: String
    let accessToken: String
}
