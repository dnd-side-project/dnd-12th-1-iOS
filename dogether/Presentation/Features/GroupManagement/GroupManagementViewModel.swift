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
    private(set) var groups: [ChallengeGroupInfo] = []
    
    private let authUseCase: AuthUseCase
    private let groupUseCase: GroupUseCase
    
    var viewStatus: GroupManagementViewStatus = .empty
    weak var delegate: GroupManagementViewModelDelegate?
    
    init() {
        let authRepository = DIManager.shared.getAuthRepository()
        let groupRepository = DIManager.shared.getGroupRepository()
        
        self.authUseCase = AuthUseCase(repository: authRepository)
        self.groupUseCase = GroupUseCase(repository: groupRepository)
    }
}

extension GroupManagementViewModel {
    func fetchMyGroup() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                let (_, groups) = try await groupUseCase.getChallengeGroupInfos()
                self.groups = groups
                viewStatus = groups.isEmpty ? .empty : .hasData
                delegate?.didFetchSucceed()
            } catch let error as NetworkError {
                delegate?.didFetchFail(error: error)
            }
        }
    }
}

extension GroupManagementViewModel {
    func leaveGroup(groupId: Int) async throws {
        try await groupUseCase.leaveGroup(groupId: groupId)
    }
}

