//
//  GroupJoinViewModel.swift
//  dogether
//
//  Created by seungyooooong on 3/26/25.
//

import Foundation

final class GroupJoinViewModel {
    private let groupUseCase: GroupUseCase
    
    let codeLength = 8
    
    private(set) var code: String = ""
    private(set) var status: GroupJoinStatus = .normal
    private(set) var challengeGroupInfo: ChallengeGroupInfo?
    
    init() {
        let groupRepository = DIManager.shared.getGroupRepository()
        self.groupUseCase = GroupUseCase(repository: groupRepository)
    }
}

extension GroupJoinViewModel {
    func setCode(_ codeInput: String?) {
        code = codeInput ?? ""
        
        if code.count > codeLength {
            code = String(code.prefix(codeLength))
        }
    }
    
    func setGroupJoinStatus(_ status: GroupJoinStatus) {
        self.status = status
    }
}

extension GroupJoinViewModel {
    func handleCodeError() {
        setGroupJoinStatus(.error)
        setCode("")
    }
    
    func joinGroup() async throws {
        challengeGroupInfo = try await groupUseCase.joinGroup(joinCode: code)
    }
}
