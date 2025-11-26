//
//  GroupJoinViewModel.swift
//  dogether
//
//  Created by seungyooooong on 3/26/25.
//

import Foundation

import RxRelay

final class GroupJoinViewModel {
    private let groupUseCase: GroupUseCase
    
    private(set) var groupJoinViewDatas = BehaviorRelay<GroupJoinViewDatas>(value: GroupJoinViewDatas())
    private(set) var joinButtonViewDatas = BehaviorRelay<DogetherButtonViewDatas>(
        value: DogetherButtonViewDatas(status: .disabled)
    )
    
    init() {
        let groupRepository = DIManager.shared.getGroupRepository()
        self.groupUseCase = GroupUseCase(repository: groupRepository)
    }
}

extension GroupJoinViewModel {
    func joinGroup() async throws -> ChallengeGroupInfo {
        try await groupUseCase.joinGroup(joinCode: groupJoinViewDatas.value.code)
    }
}

extension GroupJoinViewModel {
    func updateIsFirstResponder(isFirstResponder: Bool) {
        groupJoinViewDatas.update { $0.isFirstResponder = isFirstResponder }
    }
    
    func updateKeyboardHeight(height: CGFloat) {
        groupJoinViewDatas.update { $0.keyboardHeight = height }
    }
    
    func updateCode(code: String, codeMaxLength: Int) {
        groupJoinViewDatas.update { $0.code = code }
        joinButtonViewDatas.update {
            $0.status = code.count < codeMaxLength ? .disabled : .enabled
        }
        
        // FIXME: 임시 구현 코드, 추후 기획에 따라 수정
        if code.isEmpty { updateStatus(status: .normal) }
    }
    
    func updateStatus(status: GroupJoinStatus) {
        groupJoinViewDatas.update { $0.status = status }
    }
}
