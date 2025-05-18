//
//  PopupRepository.swift
//  dogether
//
//  Created by seungyooooong on 4/2/25.
//

import Foundation

final class PopupRepository: PopupProtocol {
    private let challengeGroupsDataSource: ChallengeGroupsDataSource
    
    init(challengeGroupsDataSource: ChallengeGroupsDataSource = .shared) {
        self.challengeGroupsDataSource = challengeGroupsDataSource
    }
    
    func certifyTodo(todoId: String, certifyTodoRequest: CertifyTodoRequest) async throws {
        try await challengeGroupsDataSource.certifyTodo(todoId: todoId, certifyTodoRequest: certifyTodoRequest)
    }
}
