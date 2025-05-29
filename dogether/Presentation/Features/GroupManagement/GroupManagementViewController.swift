//
//  GroupManagementViewController.swift
//  dogether
//
//  Created by yujaehong on 4/21/25.
//

import UIKit

final class GroupManagementViewController: BaseViewController {
    private let viewModel = GroupManagementViewModel()
    private let navigationHeader = NavigationHeader(title: "그룹 관리")
    private let emptyView = GroupEmptyView()
    private let groupTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(GroupManagementCell.self, forCellReuseIdentifier: "GroupManagementCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        groupTableView.delegate = self
        groupTableView.dataSource = self
        
        viewModel.fetchMyGroup { [weak self] in
            self?.groupTableView.reloadData()
            self?.updateEmptyViewVisibility()
        }
    }
    
    override func configureAction() {
        navigationHeader.delegate = self
        
        emptyView.createButtonTapHandler = { [weak self] in
            guard let self else { return }
            coordinator?.pushViewController(GroupCreateViewController())
        }
    }
    
    override func configureHierarchy() {
        [navigationHeader, groupTableView].forEach { view.addSubview($0) }
        view.addSubview(emptyView)
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        groupTableView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}

extension GroupManagementViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupManagementCell", for: indexPath) as? GroupManagementCell else {
            return UITableViewCell()
        }
        let group = viewModel.groups[indexPath.row]
        cell.configure(with: group)
        cell.onLeaveButtonTapped = { [weak self] in
            guard let self else { return }
            coordinator?.showPopup(self, type: .alert, alertType: .leaveGroup) { _ in
                Task {
                    try await self.viewModel.leaveGroup(groupId: group.groupId)
                    await MainActor.run {
                        self.viewModel.fetchMyGroup { [weak self] in
                            guard let self else { return }
                            groupTableView.reloadData()
                            updateEmptyViewVisibility()
                        }
                    }
                }
            }
        }
        return cell
    }
}

extension GroupManagementViewController {
    private func updateEmptyViewVisibility() {
        emptyView.isHidden = viewModel.viewStatus == .hasData
    }
}
