//
//  MainInterface.swift
//  dogether
//
//  Created by seungyooooong on 3/7/25.
//

import Foundation

protocol MainInterface {
    func getGroupStatus() async throws -> GetGroupStatusResponse
    func getGroupInfo() async throws -> GetGroupInfoResponse
    func getTeamSummary() async throws -> GetTeamSummaryResponse
    
    func getMyTodos(date: String, status: TodoStatus?) async throws -> GetMyTodosResponse
}
