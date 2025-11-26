//
//  WithdrawRequest.swift
//  dogether
//
//  Created by seungyooooong on 2/4/25.
//

import Foundation

struct WithdrawRequest: Encodable {
    let loginType: String
    let authorizationCode: String?
}
