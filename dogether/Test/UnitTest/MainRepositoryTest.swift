//
//  MainRepositoryTest.swift
//  dogether
//
//  Created by seungyooooong on 3/12/25.
//

import Foundation

final class MainRepositoryTest: MainInterface {
    func getGroupStatus() async throws -> GetGroupStatusResponse {
        return GetGroupStatusResponse(status: "READY")
//        return GetGroupStatusResponse(status: "RUNNING")
    }
    
    func getGroupInfo() async throws -> GetGroupInfoResponse {
        return GetGroupInfoResponse(
            name: "Test Group Name",
            duration: 3,
            joinCode: "000000",
            maximumTodoCount: 10,
            endAt: "25.01.01",
            remainingDays: 2
        )
    }
    
    func getTeamSummary() async throws -> GetTeamSummaryResponse {
        return GetTeamSummaryResponse(ranking: [])
    }
    
    func getMyTodos(date: String, status: TodoStatus?) async throws -> GetMyTodosResponse {
        return GetMyTodosResponse(todos: [])
    }
}
