//
//  GroupManagementViewModel.swift
//  dogether
//
//  Created by yujaehong on 4/22/25.
//

import Foundation

enum GroupManagementViewStatus {
    case empty
    case hasData
}

protocol GroupManagementViewModelDelegate: AnyObject {
    func didFetchSucceed()
    func didFetchFail(error: NetworkError)
}

final class GroupManagementViewModel {
    private(set) var groups: [ChallengeGroup] = []
    
    private let groupUseCase: GroupUseCase
    private let authUseCase: AuthUseCase
    
    var viewStatus: GroupManagementViewStatus = .empty
    weak var delegate: GroupManagementViewModelDelegate?
    
    init() {
        let groupRepository = DIManager.shared.getGroupRepository()
        let authRepository = DIManager.shared.getAuthRepository()
        self.groupUseCase = GroupUseCase(repository: groupRepository)
        self.authUseCase = AuthUseCase(repository: authRepository)
    }
}

extension GroupManagementViewModel {
    func fetchMyGroup() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                let response = try await groupUseCase.getMyGroup()
                groups = response.joiningChallengeGroups
                viewStatus = groups.isEmpty == true ? .empty : .hasData
                delegate?.didFetchSucceed()
            } catch let error as NetworkError {
                delegate?.didFetchFail(error: error)
            }
        }
    }
}

extension GroupManagementViewModel {
    func leaveGroup(groupId: Int) async throws {
        try await NetworkManager.shared.request(GroupsRouter.leaveGroup(groupId: groupId))
    }
}

