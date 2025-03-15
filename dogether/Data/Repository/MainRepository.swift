//
//  MainRepository.swift
//  dogether
//
//  Created by seungyooooong on 3/7/25.
//

import Foundation

final class MainRepository: MainInterface {
    func getGroupStatus() async throws -> GetGroupStatusResponse {
        try await GroupsDataSource.shared.getGroupStatus()
    }
    
    func getGroupInfo() async throws -> GetGroupInfoResponse {
        try await GroupsDataSource.shared.getGroupInfo()
    }
    
    func getTeamSummary() async throws -> GetTeamSummaryResponse {
        try await GroupsDataSource.shared.getTeamSummary()
    }
    
    func getMyTodos(date: String, status: TodoStatus?) async throws -> GetMyTodosResponse {
        try await TodosDataSource.shared.getMyTodos(date: date, status: status)
    }
}
