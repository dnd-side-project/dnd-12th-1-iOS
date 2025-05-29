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

final class GroupManagementViewModel {    
    private(set) var groups: [ChallengeGroup] = []
    
    private let groupUseCase: GroupUseCase
    private let authUseCase: AuthUseCase
    
    var viewStatus: GroupManagementViewStatus = .empty
    
    init() {
        let groupRepository = DIManager.shared.getGroupRepository()
        let authRepository = DIManager.shared.getAuthRepository()
        self.groupUseCase = GroupUseCase(repository: groupRepository)
        self.authUseCase = AuthUseCase(repository: authRepository)
    }
}

extension GroupManagementViewModel {
    func fetchMyGroup(completion: @escaping () -> Void) {
        Task {
            do {
                let response = try await groupUseCase.getMyGroup()
                self.groups = response.joiningChallengeGroups
                viewStatus = groups.isEmpty ? .empty : .hasData
                DispatchQueue.main.async {
                    completion()  // 데이터 갱신 후 테이블 뷰 리로드
                }
            } catch {
                self.viewStatus = .empty
                print("에러 발생: \(error)")
            }
        }
    }
}

extension GroupManagementViewModel {
    func leaveGroup(groupId: Int) async throws {
        try await NetworkManager.shared.request(GroupsRouter.leaveGroup(groupId: groupId))
    }
}

