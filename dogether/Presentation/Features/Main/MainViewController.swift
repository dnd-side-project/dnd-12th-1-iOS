//
//  MainViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/13/25.
//

import UIKit

final class MainViewController: BaseViewController {
    private let mainPage = MainPage()
    private let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        mainPage.delegate = self
        
        pages = [mainPage]

        super.viewDidLoad()
        
        onAppear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadMainView()
        
        coordinator?.updateViewController = loadMainView
    }
    
    override func setViewDatas() {
        bind(viewModel.bottomSheetViewDatas)
        bind(viewModel.groupViewDatas)
        bind(viewModel.sheetViewDatas)
        bind(viewModel.timerViewDatas)
    }
}

extension MainViewController {
    private func onAppear() {
        checkAuthorization()
        getReviews()
    }
    
    private func checkAuthorization() {
        Task { [weak self] in
            guard let self else { return }
            let userNoti = UNUserNotificationCenter.current()
            let settings = await userNoti.notificationSettings()
            
            switch settings.authorizationStatus {
            case .notDetermined:
                try await userNoti.requestAuthorization(options: [.alert, .badge, .sound])
            case .denied:
                coordinator?.showPopup(type: .alert, alertType: .pushNotice) { _ in
                    SystemManager().openSettingApp()
                }
            default:    // MARK: .authorized, .provisional, .ephemeral
                break
            }
        }
    }
    
    private func getReviews() {
        // ???: 화면 전환을 고려하면 일부러 강한 참조를 걸어야할까
        Task { [weak self] in
            guard let self else { return }
            let reviews = try await viewModel.getReviews()
            if reviews.isEmpty { return }
            
            await MainActor.run {
                self.coordinator?.showModal(reviews: reviews)
            }
        }
    }
    
    private func loadMainView() {
        Task { [weak self] in
            guard let self else { return }
            let groupViewDatas = try await viewModel.getGroups()
            viewModel.groupViewDatas.accept(groupViewDatas)
            
            if groupViewDatas.groups.isEmpty {
                coordinator?.setNavigationController(StartViewController())
                return
            }
            
            try await viewModel.setSheetViewDatasForCurrentGroup()
        }
    }
}

// MARK: - delegate
protocol MainDelegate {
    func updateAlphaBySheet(alpha: CGFloat)
    func updateSheetStatus(sheetStatus: SheetStatus)
    func updateYOffsetOfSheet(yOffset: CGFloat)
    func updateIsScrollOnTop(isScrollOnTop: Bool)
    func goRankingViewAction()
    func updateBottomSheetVisibleAction(isShowSheet: Bool)
    func selectGroupAction(index: Int)
    func addGroupAction()
    func inviteAction()
    func goPastAction()
    func goFutureAction()
    func startTimerAction()
    func stopTimerAction()
    func goWriteTodoViewAction(todos: [TodoEntity])
    func selectFilterAction(filterType: FilterTypes)
    func goCertificateViewAction(todo: TodoEntity)
    func goCertificationViewAction(index: Int)
}

extension MainViewController: MainDelegate {
    func updateAlphaBySheet(alpha: CGFloat) {
        viewModel.sheetViewDatas.update { $0.alpha = alpha }
    }
    
    func updateSheetStatus(sheetStatus: SheetStatus) {
        viewModel.sheetViewDatas.update { $0.sheetStatus = sheetStatus }
    }
    
    func updateYOffsetOfSheet(yOffset: CGFloat) {
        viewModel.sheetViewDatas.update { $0.yOffset = yOffset }
    }
    
    func updateIsScrollOnTop(isScrollOnTop: Bool) {
        viewModel.sheetViewDatas.update { $0.isScrollOnTop = isScrollOnTop }
    }
    
    func goRankingViewAction() {
        let rankingViewController = RankingViewController()
        let rankingViewDatas = RankingViewDatas(groupId: viewModel.currentGroup.id)
        coordinator?.pushViewController(rankingViewController, datas: rankingViewDatas)
    }
    
    func updateBottomSheetVisibleAction(isShowSheet: Bool) {
        viewModel.bottomSheetViewDatas.update { $0.isShowSheet = isShowSheet }
    }
    
    func selectGroupAction(index: Int) {
        viewModel.groupViewDatas.update { $0.index = index }
        viewModel.saveLastSelectedGroupIndex(index: index)
        
        viewModel.sheetViewDatas.update { $0.dateOffset = 0 }
        
        Task {
            try await viewModel.setSheetViewDatasForCurrentGroup()
        }
    }
    
    func addGroupAction() {
        let startViewController = StartViewController()
        let startViewDatas = StartViewDatas(isFirstGroup: false)
        coordinator?.pushViewController(startViewController, datas: startViewDatas)
    }
    
    func inviteAction() {
        let inviteGroup = SystemManager.inviteGroup(groupName: viewModel.currentGroup.name, joinCode: viewModel.currentGroup.joinCode)
        present(UIActivityViewController(activityItems: inviteGroup, applicationActivities: nil), animated: true)
    }
    
    func goPastAction() {
        viewModel.sheetViewDatas.update {
            $0.dateOffset -= 1
            $0.filter = .all
        }
        
        Task {
            try await viewModel.setSheetViewDatasForCurrentGroup()
        }
    }
    
    func goFutureAction() {
        viewModel.sheetViewDatas.update {
            $0.dateOffset += 1
            $0.filter = .all
        }
        
        Task {
            try await viewModel.setSheetViewDatasForCurrentGroup()
        }
    }
    
    func startTimerAction() {
        viewModel.startTimer()
    }
    
    func stopTimerAction() {
        viewModel.stopTimer()
    }
    
    func goWriteTodoViewAction(todos: [TodoEntity]) {
        let todoWriteViewController = TodoWriteViewController()
        let todoWriteViewDatas = TodoWriteViewDatas(
            groupId: viewModel.currentGroup.id,
            todos: todos.map { WriteTodoEntity(content: $0.content, enabled: false) }
        )
        coordinator?.pushViewController(todoWriteViewController, datas: todoWriteViewDatas)
    }
    
    func selectFilterAction(filterType: FilterTypes) {
        let filter = filterType == viewModel.sheetViewDatas.value.filter ? .all : filterType
        viewModel.sheetViewDatas.update { $0.filter = filter }
    }
    
    func goCertificateViewAction(todo: TodoEntity) {
        let certificateImageViewController = CertificateImageViewController()
        let certificateViewDatas = CertificateViewDatas(todo: todo)
        coordinator?.pushViewController(certificateImageViewController, datas: certificateViewDatas)
    }
    
    func goCertificationViewAction(index: Int) {
        let certificationViewController = CertificationViewController()
        let certificationViewDatas = CertificationViewDatas(
            title: "내 인증 정보",
            todos: viewModel.sheetViewDatas.value.todoList.filter {
                viewModel.sheetViewDatas.value.filter == .all || viewModel.sheetViewDatas.value.filter == FilterTypes(status: $0.status.rawValue)
            },
            index: index
        )
        coordinator?.pushViewController(certificationViewController, datas: certificationViewDatas)
    }
}
