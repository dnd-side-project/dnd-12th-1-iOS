//
//  CertificationListProtocol.swift
//  dogether
//
//  Created by yujaehong on 5/6/25.
//

import Foundation

protocol CertificationListProtocol {
    func fetchByTodoCompletionDate() async throws -> CertificationListResult
    func fetchByGroupCreationDate() async throws -> CertificationListResult
}
