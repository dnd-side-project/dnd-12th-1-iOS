//
//  GroupManagementViewController.swift
//  dogether
//
//  Created by yujaehong on 4/21/25.
//

import Foundation

final class GroupManagementViewController: BaseViewController {
    private let groupManagementPage = GroupManagementPage()
    private let viewModel = GroupManagementViewModel()

    override func viewDidLoad() {
        groupManagementPage.delegate = self
        
        pages = [groupManagementPage]
        
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadGroups()
        
        coordinator?.updateViewController = loadGroups
    }

    override func setViewDatas() {
        bind(viewModel.groupManagementViewDatas)
    }
}

extension GroupManagementViewController {
    private func loadGroups() {
        Task { [weak self] in
            guard let self else { return }
            try await viewModel.loadGroups()
        }
    }
}

// MARK: - delegate
protocol GroupManagementDelegate: AnyObject {
    func leaveGroupAction(_ group: GroupEntity)
    func addGroupAction()
}

extension GroupManagementViewController: GroupManagementDelegate {
    func leaveGroupAction(_ group: GroupEntity) {
        coordinator?.showPopup(type: .alert, alertType: .leaveGroup) { [weak self] _ in
            guard let self else { return }
            Task { [weak self] in
                guard let self else { return }
                try await viewModel.leaveGroup(groupId: group.id)
                loadGroups()
            }
        }
    }
    
    func addGroupAction() {
        coordinator?.pushViewController(GroupCreateViewController())
    }
}
