//
//  MainUseCase.swift
//  dogether
//
//  Created by seungyooooong on 3/7/25.
//

import Foundation

final class MainUseCase {
    private let repository: MainInterface
    
    init(repository: MainInterface) {
        self.repository = repository
    }
    
    func getMainViewStatus() async throws -> MainViewStatus {
        let response = try await repository.getGroupStatus()
        let groupStatus = response.status
        return groupStatus == "READY" ? .beforeStart : .emptyList
    }
    
    func getGroupInfo() async throws -> GroupInfo {
        let response = try await repository.getGroupInfo()
        return GroupInfo(
            name: response.name,
            duration: response.duration,
            joinCode: response.joinCode,
            maximumTodoCount: response.maximumTodoCount,
            endAt: response.endAt,
            remainingDays: response.remainingDays
        )
    }
    
    func getTodoList(dateOffset: Int, currentFilter: FilterTypes) async throws -> [TodoInfo] {
        let date = DateFormatterManager.formattedDate(dateOffset).split(separator: ".").joined(separator: "-")
        let status: TodoStatus? = currentFilter == .all ? nil : TodoStatus.allCases.first(where: { $0.tag == currentFilter.tag })
        
        let response = try await repository.getMyTodos(date: date, status: status)
        return response.todos
    }
    
    func navigateToTodoWriteView(maximumTodoCount: Int) {
        Task { @MainActor in
            let todoWriteViewController = TodoWriteViewController()
            todoWriteViewController.maximumTodoCount = maximumTodoCount
            NavigationManager.shared.pushViewController(todoWriteViewController)
        }
    }
    
    func navigateToRankingView() {
        Task {
            let response = try await repository.getTeamSummary()
            await MainActor.run {
                let rankingViewController = RankingViewController()
                rankingViewController.rankings = response.ranking
                NavigationManager.shared.pushViewController(rankingViewController)
            }
        }
    }
    
//    func showPopup(type: PopupTypes, todoInfo: TodoInfo) {
//        PopupManager.shared.showPopup(type: type, todoInfo: todoInfo)
//    }
}
