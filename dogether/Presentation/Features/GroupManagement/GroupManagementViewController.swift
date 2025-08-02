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
    private var errorView: ErrorView?
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
        viewModel.delegate = self
        viewModel.fetchMyGroup()
    }
    
    override func configureView() {
        groupTableView.delegate = self
        groupTableView.dataSource = self
    }
    
    override func configureAction() {
        navigationHeader.delegate = self
        emptyView.createButtonTapHandler = { [weak self] in
            self?.coordinator?.pushViewController(GroupCreateViewController())
        }
    }
    
    override func configureHierarchy() {
        [navigationHeader, emptyView].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
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
            coordinator?.showPopup(self, type: .alert, alertType: .leaveGroup) { [weak self] _ in
                guard let self else { return }
                tryLeaveGroup(groupId: group.id)
            }
        }
        return cell
    }
}

extension GroupManagementViewController {
    private func displayViewForCurrentStatus() {
        errorView?.removeFromSuperview()
        
        switch viewModel.viewStatus {
        case .empty:
            emptyView.isHidden = false
            groupTableView.removeFromSuperview()
        case .hasData:
            if groupTableView.superview == nil {
                view.addSubview(groupTableView)
                groupTableView.snp.makeConstraints {
                    $0.top.equalTo(navigationHeader.snp.bottom).offset(4)
                    $0.horizontalEdges.equalToSuperview().inset(16)
                    $0.bottom.equalToSuperview()
                }
            }
            groupTableView.reloadData()
            emptyView.isHidden = true
        }
    }
}

extension GroupManagementViewController: GroupManagementViewModelDelegate {
    func didFetchSucceed() {
        displayViewForCurrentStatus()
    }
    
    func didFetchFail(error: NetworkError) {
        emptyView.removeFromSuperview()
        groupTableView.removeFromSuperview()
        errorView?.removeFromSuperview()
        
        let newErrorView = ErrorHandlingManager.embedErrorView(
            in: self,
            under: navigationHeader,
            error: error,
            retryHandler: { [weak self] in
                guard let self else { return }
                viewModel.fetchMyGroup()
            }
        )
        errorView = newErrorView
    }
}

extension GroupManagementViewController {
    private func tryLeaveGroup(groupId: Int) {
        Task {
            do {
                try await viewModel.leaveGroup(groupId: groupId)
                await MainActor.run {
                    viewModel.fetchMyGroup()
                }
            } catch let error as NetworkError {
                ErrorHandlingManager.presentErrorView(
                    error: error,
                    presentingViewController: self,
                    coordinator: coordinator,
                    retryHandler: { [weak self] in
                        guard let self else { return }
                        tryLeaveGroup(groupId: groupId)
                    }
                )
            }
        }
    }
}
