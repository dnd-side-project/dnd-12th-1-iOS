//
//  MainViewModel.swift
//  dogether
//
//  Created by seungyooooong on 2/13/25.
//

import Foundation
import UIKit

final class MainViewModel {
    private let mainUseCase: MainUseCase
    
    private(set) var mainViewStatus: MainViewStatus = .emptyList
    
    private(set) var groupInfo: GroupInfo = GroupInfo()
    
    private(set) var sheetStatus: SheetStatus = .normal
    private(set) var isBlockPanGesture: Bool = true
    
    private(set) var timer: Timer?
    private(set) var time: String = "23:59:59"
    private(set) var timeProgress: CGFloat = 0.0
    
    private(set) var dateOffset: Int = 0
    private(set) var currentFilter: FilterTypes = .all
    private(set) var todoList: [TodoInfo] = []
    
    // MARK: - Computed
    var todoListHeight: Int { todoList.isEmpty ? 0 : 64 * todoList.count + 8 * (todoList.count - 1) }
    
    init() {
        let mainRepository = MainRepository()
        self.mainUseCase = MainUseCase(repository: mainRepository)
    }
}

// MARK: - load view
extension MainViewModel {
    func loadMainView(updateView: @escaping () -> Void, updateTimer: @escaping () -> Void, updateList: @escaping () -> Void) {
        Task {
            mainViewStatus = try await mainUseCase.getMainViewStatus()
            groupInfo = try await mainUseCase.getGroupInfo()
            await MainActor.run { updateView() }
            loadMainViewDetail(updateTimer: updateTimer, updateList: updateList)
        }
    }
    
    func loadMainViewDetail(updateTimer: @escaping () -> Void, updateList: @escaping () -> Void) {
        if mainViewStatus == .beforeStart {
            startCountdown(updateTimer: updateTimer, updateList: updateList)
        } else {
            updateListInfo(updateList: updateList)
        }
    }
}

// MARK: - beforeStart
extension MainViewModel {
    private func startCountdown(updateTimer: @escaping () -> Void, updateList: @escaping () -> Void) {
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
            self.updateTimerInfo(remainTime: remainTime, updateTimer: updateTimer)
        } else {
            self.stopCountdown()
            self.updateListInfo(updateList: updateList)
        }
    }
    
    private func updateTimerInfo(remainTime: TimeInterval, updateTimer: @escaping () -> Void) {
        self.time = remainTime.formatToHHmmss()
        self.timeProgress = remainTime.getTimeProgress()
        Task { @MainActor in updateTimer() }
    }
}
    
// MARK: - todoList
extension MainViewModel {
//    func didTapTodoItem(todo: TodoInfo) {
//        let popupType: PopupTypes = TodoStatus(rawValue: todo.status) == .waitCertificattion ? .certification : .certificationInfo
//        mainUseCase.showPopup(type: popupType, todoInfo: todo)
//    }
    
    func updateFilter(filter: FilterTypes, completeAction: @escaping () -> Void) {
        self.currentFilter = filter
        
        updateListInfo(updateList: completeAction)
    }
    
    private func updateListInfo(updateList: @escaping () -> Void) {
        Task {
            todoList = try await mainUseCase.getTodoList(dateOffset: dateOffset, currentFilter: currentFilter)
            mainViewStatus = currentFilter == .all && todoList.isEmpty ? .emptyList : .todoList
            isBlockPanGesture = await todoListHeight < Int(UIScreen.main.bounds.height - (SheetStatus.normal.offset + 140 + 48))
            await MainActor.run { updateList() }
        }
    }
}

// MARK: - about sheet
extension MainViewModel {
    func setIsBlockPanGesture(_ isBlockPanGesture: Bool) {
        self.isBlockPanGesture = isBlockPanGesture
    }
    
    func getNewOffset(from currentOffset: CGFloat, with translation: CGFloat) -> CGFloat {
        switch sheetStatus {
        case .expand:
            if translation > 0 { return min(SheetStatus.normal.offset, translation) }
            return currentOffset
        case .normal:
            if translation < 0 { return max(0, SheetStatus.normal.offset + translation) }
            return currentOffset
        }
    }
    
    func updateSheetStatus(with translation: CGFloat, completeAction: @escaping (SheetStatus) -> Void) {
        switch sheetStatus {
        case .expand:
            sheetStatus = translation > 100 ? .normal : .expand
        case .normal:
            sheetStatus = translation < -100 ? .expand : .normal
        }
        
        completeAction(sheetStatus)
    }
}

// MARK: - navigate
extension MainViewModel {
    func navigateToTodoWriteView() {
        mainUseCase.navigateToTodoWriteView(maximumTodoCount: groupInfo.maximumTodoCount)
    }
    
    func navigateToRankingView() {
        mainUseCase.navigateToRankingView()
    }
}
