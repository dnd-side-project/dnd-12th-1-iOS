//
//  RankingViewModel.swift
//  dogether
//
//  Created by seungyooooong on 4/10/25.
//

import UIKit

import RxRelay

final class RankingViewModel {
    private let groupUseCase: GroupUseCase
    private let challengeGroupsUseCase: ChallengeGroupUseCase
    
    private(set) var rankingViewDatas = BehaviorRelay<RankingViewDatas>(value: RankingViewDatas())
    
    init() {
        let groupRepository = DIManager.shared.getGroupRepository()
        let challengeGroupsRepository = DIManager.shared.getChallengeGroupsRepository()
        
        self.groupUseCase = GroupUseCase(repository: groupRepository)
        self.challengeGroupsUseCase = ChallengeGroupUseCase(repository: challengeGroupsRepository)
    }
}

extension RankingViewModel {
    func loadRankingView() async throws {
        try await getRankings()
    }
}

extension RankingViewModel {
    func getRankings() async throws {
        let rankings = try await groupUseCase.getRankings(groupId: rankingViewDatas.value.groupId)
        rankingViewDatas.update { $0.rankings = rankings }
    }
    
    func getMemberTodos(memberId: Int) async throws -> (Int, [TodoEntity]) {
        try await challengeGroupsUseCase.getMemberTodos(groupId: rankingViewDatas.value.groupId, memberId: memberId)
    }
}
