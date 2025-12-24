//
//  GroupManagementViewModel.swift
//  dogether
//
//  Created by yujaehong on 4/22/25.
//

import RxRelay

final class GroupManagementViewModel {
    private let authUseCase: AuthUseCase
    private let groupUseCase: GroupUseCase
    
    private(set) var groupManagementViewDatas = BehaviorRelay<GroupManagementViewDatas>(value: GroupManagementViewDatas())
    
    init() {
        let authRepository = DIManager.shared.getAuthRepository()
        let groupRepository = DIManager.shared.getGroupRepository()
        
        self.authUseCase = AuthUseCase(repository: authRepository)
        self.groupUseCase = GroupUseCase(repository: groupRepository)
    }
}

extension GroupManagementViewModel {
    func loadGroups() async throws {
        let (_, groups) = try await groupUseCase.getGroups()
        groupManagementViewDatas.update { $0.groups = groups }
    }
    
    func leaveGroup(groupId: Int) async throws {
        try await groupUseCase.leaveGroup(groupId: groupId)
    }
}
