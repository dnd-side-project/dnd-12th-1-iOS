//
//  MainViewModel.swift
//  dogether
//
//  Created by seungyooooong on 2/13/25.
//

import UIKit

final class MainViewModel {
    private let mainUseCase: MainUseCase
    private let groupUseCase: GroupUseCase
    private let challengeGroupsUseCase: ChallengeGroupUseCase
    private let todoCertificationsUseCase: TodoCertificationsUseCase
    
    private(set) var rankings: [RankingModel]?
    
    private(set) var challengeGroupInfos: [ChallengeGroupInfo] = []
    
    var currentGroup: ChallengeGroupInfo {
        challengeGroupInfos[currentChallengeIndex]
    }
    
    private(set) var currentChallengeIndex: Int = 0
    
    private(set) var sheetStatus: SheetStatus = .normal
    
    private(set) var timer: Timer?
    private(set) var time: String = "23:59:59"
    private(set) var timeProgress: CGFloat = 0.0
    
    private(set) var dateOffset: Int = 0
    private(set) var currentFilter: FilterTypes = .all
    private(set) var todoList: [TodoInfo] = []
    
    var selectedGroup: ChallengeGroupInfo? = nil

    // MARK: - Computed
    var todoListHeight: Int { todoList.isEmpty ? 0 : 64 * todoList.count + 8 * (todoList.count - 1) }
    
    init() {
        let groupRepository = DIManager.shared.getGroupRepository()
        let challengeGroupsRepository = DIManager.shared.getChallengeGroupsRepository()
        let todoCertificationsRepository = DIManager.shared.getTodoCertificationsRepository()
        
        self.mainUseCase = MainUseCase()
        self.groupUseCase = GroupUseCase(repository: groupRepository)
        self.challengeGroupsUseCase = ChallengeGroupUseCase(repository: challengeGroupsRepository)
        self.todoCertificationsUseCase = TodoCertificationsUseCase(repository: todoCertificationsRepository)
    }
}

// MARK: - load view
extension MainViewModel {
    func loadMainView(selectedIndex: Int? = nil, noGroupAction: @escaping () -> Void) async throws {
        let (groupIndex, newChallengeGroupInfos) = try await groupUseCase.getChallengeGroupInfos()
        
        if let groupIndex {
            currentChallengeIndex = selectedIndex ?? groupIndex
            challengeGroupInfos = newChallengeGroupInfos
        } else {
            noGroupAction()
        }
    }
    
    func getReviews() async throws -> [ReviewModel] {
        try await todoCertificationsUseCase.getReviews()
    }
}

// MARK: - set
extension MainViewModel {
    func setChallengeIndex(index: Int) {
        self.currentChallengeIndex = index
    }
    
    func setDateOffset(offset: Int) {
        self.dateOffset = offset
    }
    
    func setFilter(filter: FilterTypes) {
        self.currentFilter = filter
    }
}

// MARK: - ready
extension MainViewModel {
    func startCountdown(updateTimer: @escaping () -> Void, updateList: @escaping () -> Void) {
        checkRemainTime(updateTimer: updateTimer, updateList: updateList)
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                self.checkRemainTime(updateTimer: updateTimer, updateList: updateList)
            }
        }
    }
    
    private func stopCountdown() {
        timer?.invalidate()
        timer = nil
    }
    
    private func checkRemainTime(updateTimer: @escaping () -> Void, updateList: @escaping () -> Void) {
        let remainTime = Date().getRemainTime()
        
        if remainTime > 0 {
            updateTimerInfo(remainTime: remainTime, updateTimer: updateTimer)
        } else {
            stopCountdown()
            updateListInfo(updateList: updateList)
        }
    }
    
    private func updateTimerInfo(remainTime: TimeInterval, updateTimer: @escaping () -> Void) {
        self.time = remainTime.formatToHHmmss()
        self.timeProgress = remainTime.getTimeProgress()
        Task { @MainActor in updateTimer() }
    }
    
    private func updateListInfo(updateList: @escaping () -> Void) {
        Task {
            let (date, status) = try await mainUseCase.getTodosInfo(dateOffset: dateOffset, currentFilter: currentFilter)
            todoList = try await challengeGroupsUseCase.getMyTodos(groupId: currentGroup.id, date: date, status: status)
            await MainActor.run { updateList() }
        }
    }
}
    
// MARK: - todoList
extension MainViewModel {
    func updateListInfo() async throws {
        let (date, status) = try await mainUseCase.getTodosInfo(dateOffset: dateOffset, currentFilter: currentFilter)
        todoList = try await challengeGroupsUseCase.getMyTodos(groupId: currentGroup.id, date: date, status: status)
    }
}

// MARK: - about sheet
extension MainViewModel {
    func getNewOffset(from currentOffset: CGFloat, with translation: CGFloat) -> CGFloat {
        switch sheetStatus {
        case .expand:
            if translation > 0 { return min(SheetStatus.normal.offset, SheetStatus.expand.offset + translation) }
            return currentOffset
        case .normal:
            if translation < 0 { return max(0, SheetStatus.normal.offset + translation) }
            return currentOffset
        }
    }
    
    func updateSheetStatus(with translation: CGFloat) -> SheetStatus {
        switch sheetStatus {
        case .expand:
            sheetStatus = translation > 100 ? .normal : .expand
        case .normal:
            sheetStatus = translation < -100 ? .expand : .normal
        }
        return sheetStatus
    }
}

extension MainViewModel {
    func saveLastSelectedGroup() {
        Task {
            try await groupUseCase.saveLastSelectedGroup(groupId: selectedGroup?.id)
        }
    }
}
