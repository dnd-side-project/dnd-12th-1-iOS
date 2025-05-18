//
//  ChallengeGroupsProtocol.swift
//  dogether
//
//  Created by seungyooooong on 3/30/25.
//

import Foundation

protocol ChallengeGroupsProtocol {
    func createTodos(groupId: String, createTodosRequest: CreateTodosRequest) async throws
    func getMyTodos(groupId: String, date: String, status: String?) async throws -> GetMyTodosResponse
    func getMemberTodos(groupId: String, memberId: String) async throws -> GetMemberTodosResponse
    func readTodo(todoId: String) async throws
}
