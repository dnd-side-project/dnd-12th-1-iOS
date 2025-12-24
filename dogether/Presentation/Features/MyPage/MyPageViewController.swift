//
//  MyPageViewController.swift
//  dogether
//
//  Created by seungyooooong on 3/31/25.
//

final class MyPageViewController: BaseViewController {
    private let myPage = MyPagePage()
    private let viewModel = MyPageViewModel()
    
    override func viewDidLoad() {
        myPage.delegate = self
        
        pages = [myPage]
        
        super.viewDidLoad()
        
        onAppear()
    }
    
    override func setViewDatas() {
        bind(viewModel.profileViewDatas)
        bind(viewModel.statsButtonViewDatas)
    }
}

extension MyPageViewController {
    private func onAppear() {
        Task { [weak self] in
            guard let self else { return }
            try await viewModel.loadProfileView()
        }
    }
}

protocol MyPageDelegate: AnyObject {
    func goStatsViewAction()
    func goMyTodoListAction()
    func goGroupManagementAction()
    func goSettingViewAction()
}

extension MyPageViewController: MyPageDelegate {
    func goStatsViewAction() {
        coordinator?.pushViewController(StatsViewController())
    }
    func goMyTodoListAction() {
        coordinator?.pushViewController(CertificationListViewController())
    }
    func goGroupManagementAction() {
        coordinator?.pushViewController(GroupManagementViewController())
    }
    func goSettingViewAction() {
        coordinator?.pushViewController(SettingViewController())
    }
}
