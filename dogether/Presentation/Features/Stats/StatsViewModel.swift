//
//  StatsViewModel.swift
//  dogether
//
//  Created by yujaehong on 4/22/25.
//

import Foundation
import RxRelay

final class StatsViewModel {
    private let userUseCase: UserUseCase
    private let groupUseCase: GroupUseCase
    
    private(set) var bottomSheetViewDatas = BehaviorRelay<BottomSheetViewDatas>(value: BottomSheetViewDatas())
    private(set) var groupViewDatas = BehaviorRelay<GroupViewDatas>(value: GroupViewDatas())
    private(set) var achievementViewDatas = BehaviorRelay<AchievementViewDatas>(value: AchievementViewDatas())
    private(set) var myRankViewDatas = BehaviorRelay<StatsRankViewDatas>(value: StatsRankViewDatas())
    private(set) var summaryViewDatas = BehaviorRelay<StatsSummaryViewDatas>(value: StatsSummaryViewDatas())
    
    // MARK: - Computed
    var currentGroup: GroupEntity { groupViewDatas.value.groups[groupViewDatas.value.index] }
    
    init() {
        let userRepository = DIManager.shared.getUserRepository()
        let groupRepository = DIManager.shared.getGroupRepository()
        
        self.userUseCase = UserUseCase(repository: userRepository)
        self.groupUseCase = GroupUseCase(repository: groupRepository)
    }
}

extension StatsViewModel {
    func loadStatsView() async throws {
        try await fetchMyGroups()
    }
}

extension StatsViewModel {
    private func fetchMyGroups() async throws {
        let (groupIndex, groups) = try await groupUseCase.getGroups()
        
        guard let groupIndex else { return }
        groupViewDatas.accept(GroupViewDatas(index: groupIndex, groups: groups))
        
        try await fetchStatsViewDatas()
    }
}

extension StatsViewModel {
    func fetchStatsViewDatas() async throws {
        let (achievement, myRank, summary) = try await userUseCase.getStatsViewDatas(groupId: currentGroup.id)
        
        achievementViewDatas.accept(achievement)
        myRankViewDatas.accept(myRank)
        summaryViewDatas.accept(summary)
    }
}

extension StatsViewModel {
    func saveLastSelectedGroupIndex(index: Int) {
        Task {
            try await groupUseCase.saveLastSelectedGroup(groupId: groupViewDatas.value.groups[index].id)
        }
    }
}
