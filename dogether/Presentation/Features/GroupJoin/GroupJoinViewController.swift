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
        Task {
            do {
                let groupInfo = try await viewModel.joinGroup()
                await MainActor.run {
                    coordinator?.setNavigationController(
                        CompleteViewController(),
                        datas: CompleteViewDatas(
                            groupType: .join,
                            groupEntity: groupInfo
                        )
                    )
                }
            } catch let error as NetworkError {
                if case let .dogetherError(code, _) = error {
                    guard let alertType: AlertTypes =
                            code == .CGF0002 ? .alreadyParticipated :
                                code == .CGF0003 ? .fullGroup :
                                code == .CGF0004 || code == .CGF0005 ? .unableToParticipate :
                                nil else { return }
                    
                    coordinator?.showPopup(type: .alert, alertType: alertType) { [weak self] _ in
                        guard let self else { return }
                        coordinator?.popViewController()
                    }
                }
            }
        }
    }
}
