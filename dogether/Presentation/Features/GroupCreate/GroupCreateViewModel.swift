//
//  GroupCreateViewModel.swift
//  dogether
//
//  Created by seungyooooong on 2/10/25.
//

import Foundation

final class GroupCreateViewModel {
    private let groupUseCase: GroupUseCase
    
    let maxStep: Int = 3
    let groupNameMaxLength: Int = 10
    
    private(set) var joinCode: String?
    private(set) var currentStep: CreateGroupSteps = .one
    private(set) var currentGroupName: String = ""
    private(set) var memberCount: Int = 10
    private(set) var currentDuration: GroupChallengeDurations = .threeDays
    private(set) var currentStartAt: GroupStartAts = .today
    
    init() {
        let groupRepository = DIManager.shared.getGroupRepository()
        self.groupUseCase = GroupUseCase(repository: groupRepository)
    }
}

extension GroupCreateViewModel {
    func updateStep(step: CreateGroupSteps) {
        currentStep = step
    }
    
    func updateGroupName(groupName: String?) {
        currentGroupName = groupName ?? ""
        
        if currentGroupName.count > groupNameMaxLength {
            currentGroupName = String(currentGroupName.prefix(groupNameMaxLength))
        }
    }
    
    func updateMemberCount(count: Int) {
        memberCount = count
    }
    
    func updateDuration(duration: GroupChallengeDurations) {
        currentDuration = duration
    }
    
    func updateStartAt(startAt: GroupStartAts) {
        currentStartAt = startAt
    }
}

extension GroupCreateViewModel {
    func createGroup() async throws {
        joinCode = try await groupUseCase.createGroup(
            groupName: currentGroupName,
            maximumMemberCount: memberCount,
            startAt: currentStartAt,
            duration: currentDuration
        )
    }
}
