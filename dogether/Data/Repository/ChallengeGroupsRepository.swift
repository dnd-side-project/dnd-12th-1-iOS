//
//  ChallengeGroupsRepository.swift
//  dogether
//
//  Created by seungyooooong on 3/30/25.
//

import Foundation

final class ChallengeGroupsRepository: ChallengeGroupsProtocol {
    private let challengeGroupsDataSource: ChallengeGroupsDataSource
    
    init(challengeGroupsDataSource: ChallengeGroupsDataSource = .shared) {
        self.challengeGroupsDataSource = challengeGroupsDataSource
    }
    
    func createTodos(groupId: String, createTodosRequest: CreateTodosRequest) async throws {
        try await challengeGroupsDataSource.createTodos(groupId: groupId, createTodosRequest: createTodosRequest)
    }
    
    func getMyTodos(groupId: String, date: String, status: String?) async throws -> GetMyTodosResponse {
        try await challengeGroupsDataSource.getMyTodos(groupId: groupId, date: date, status: status)
    }
    
    func getMemberTodos(groupId: String, memberId: String) async throws -> GetMemberTodosResponse {
        try await challengeGroupsDataSource.getMemberTodos(groupId: groupId, memberId: memberId)
    }
    
    func readTodo(todoId: String) async throws {
        try await challengeGroupsDataSource.readTodo(todoId: todoId)
    }
}
