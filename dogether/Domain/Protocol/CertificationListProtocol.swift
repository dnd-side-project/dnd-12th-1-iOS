//
//  CertificationListProtocol.swift
//  dogether
//
//  Created by yujaehong on 5/6/25.
//

import Foundation

protocol CertificationListProtocol {
    func fetchByTodoCompletionDate(sort: String, page: String) async throws -> CertificationListResult
    func fetchByGroupCreationDate(sort: String, page: String) async throws -> CertificationListResult
}
