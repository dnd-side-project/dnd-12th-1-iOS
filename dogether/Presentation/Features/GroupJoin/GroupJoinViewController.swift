//
//  GroupJoinViewController.swift
//  dogether
//
//  Created by seungyooooong on 11/19/25.
//

import UIKit

final class GroupJoinViewController: BaseViewController {
    private let groupJoinPage = GroupJoinPage()
    private let viewModel = GroupJoinViewModel()
    
    override func viewDidLoad() {
        groupJoinPage.delegate = self
        
        pages = [groupJoinPage]
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.updateIsFirstResponder(isFirstResponder: true)
    }
    
    override func setViewDatas() {
        bind(viewModel.groupJoinViewDatas)
        bind(viewModel.joinButtonViewDatas)
    }
}

extension GroupJoinViewController {
    private func tryJoinGroup() {
        Task {
            do {
                let groupInfo = try await viewModel.joinGroup()
                await MainActor.run {
                    coordinator?.setNavigationController(
                        CompleteViewController(),
                        datas: CompleteViewDatas(
                            groupType: .join,
                            groupInfo: groupInfo
                        )
                    )
                }
            } catch let error as NetworkError {
                if case let .dogetherError(code, _) = error, code == .CGF0005 {
                    await MainActor.run { [weak self] in
                        guard let self else { return }
                        viewModel.updateStatus(status: .invalidCode)
                    }
                } else {
                    ErrorHandlingManager.presentErrorView(
                        error: error,
                        presentingViewController: self,
                        coordinator: coordinator,
                        retryHandler: { [weak self] in
                            guard let self else { return }
                            tryJoinGroup()
                        }
                    )
                }
            }
        }
    }
}

protocol GroupJoinDelegate {
    func updateCodeAction(code: String, codeMaxLength: Int)
    func updateKeyboardHeightAction(height: CGFloat)
    func joinGroupAction()
}

extension GroupJoinViewController: GroupJoinDelegate {
    func updateCodeAction(code: String, codeMaxLength: Int) {
        viewModel.updateCode(code: code, codeMaxLength: codeMaxLength)
    }
    
    func updateKeyboardHeightAction(height: CGFloat) {
        viewModel.updateKeyboardHeight(height: height)
    }
    
    func joinGroupAction() {
        tryJoinGroup()  // FIXME: 추후 수정
    }
}
