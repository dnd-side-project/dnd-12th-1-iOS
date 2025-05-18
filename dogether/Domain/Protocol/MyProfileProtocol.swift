//
//  MyProfileProtocol.swift
//  dogether
//
//  Created by yujaehong on 5/17/25.
//

import Foundation

protocol MyProfileProtocol {
    func getMyProfile() async throws -> MyProfileResponse
}
