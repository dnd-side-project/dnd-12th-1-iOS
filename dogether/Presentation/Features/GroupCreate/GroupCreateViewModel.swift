//
//  GroupCreateViewModel.swift
//  dogether
//
//  Created by seungyooooong on 2/10/25.
//

import Foundation

import RxRelay

final class GroupCreateViewModel {
    private let groupUseCase: GroupUseCase
    
    private(set) var groupCreateViewDatas = BehaviorRelay<GroupCreateViewDatas>(value: GroupCreateViewDatas())
    
    init() {
        let groupRepository = DIManager.shared.getGroupRepository()
        self.groupUseCase = GroupUseCase(repository: groupRepository)
    }
}

extension GroupCreateViewModel {
    func updateIsFirstResponder(isFirstResponder: Bool) {
        groupCreateViewDatas.update { $0.isFirstResponder = isFirstResponder }
    }
    
    func updateStep(step: CreateGroupSteps?) {
        guard let step else { return }
        groupCreateViewDatas.update { $0.step = step }
    }
    
    func updateGroupName(groupName: String) {
        groupCreateViewDatas.update { $0.groupName = groupName}
    }
    
    func updateMemberCount(count: Int, min: Int, max: Int) {
        let isValidate = groupUseCase.validateMemberCount(count: count, min: min, max: max)
        if isValidate { groupCreateViewDatas.update { $0.memberCount = count } }
    }
    
    func updateDuration(duration: GroupChallengeDurations) {
        groupCreateViewDatas.update { $0.duration = duration }
    }
    
    func updateStartAt(startAt: GroupStartAts) {
        groupCreateViewDatas.update { $0.startAt = startAt }
    }
}

extension GroupCreateViewModel {
    func createGroup() async throws -> String {
        try await groupUseCase.createGroup(groupCreateViewDatas: groupCreateViewDatas.value)
    }
}
