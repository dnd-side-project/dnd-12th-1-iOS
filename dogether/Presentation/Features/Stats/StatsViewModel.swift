//
//  StatsViewModel.swift
//  dogether
//
//  Created by yujaehong on 4/22/25.
//

import Foundation

enum StatsViewStatus {
    case empty
    case hasData
}

protocol StatsViewModelDelegate: AnyObject {
    func didFetchStatsSucceed()
    func didFetchStatsFail(error: NetworkError)
}

struct GroupSortOption: BottomSheetItemRepresentable, Hashable {
    let groupId: Int
    let groupName: String
    
    var displayName: String {
        return groupName
    }
    
    var bottomSheetItem: BottomSheetItem {
        BottomSheetItem(displayName: displayName, value: self)
    }
}

final class StatsViewModel {
    
    private let statsUseCase: StatsUseCase
    private let groupUseCase: GroupUseCase
    
    weak var delegate: StatsViewModelDelegate?
    
    var statsViewStatus: StatsViewStatus = .empty
    
    var groupName: String = ""
    var endDate: String = ""
    var maximumMemberCount: Int = 0
    var currentMemberCount: Int = 0
    var joinCode: String = ""
    
    var dailyAchievements: [CertificationPeriod] = []
    var myRank: Int = 0
    var totalMembers: Int = 0
    var statsSummary: Stats?
    
    var groups: [ChallengeGroupInfo] = [] // 받아온 그룹 아이디를 통해 특정 그룹 활동 통계 조회
    var groupSortOptions: [GroupSortOption] = []
    
    var selectedGroup: GroupSortOption? // 현재 선택된 그룹
    
    init() {
        let statsrepository = DIManager.shared.getStatsRepository()
        let groupRepository = DIManager.shared.getGroupRepository()
        self.statsUseCase = StatsUseCase(repository: statsrepository)
        self.groupUseCase = GroupUseCase(repository: groupRepository)
    }
}

extension StatsViewModel {
    /// 특정 그룹내 정보조회
    private func fetchStats(groupId: Int) {
        Task {
            do {
                let response = try await statsUseCase.fetchGroupStats(groupId: groupId)
                // FIXME: 해당 변수들을 다 포함하는 모델을 하나 만드는 게 나을 것 같아요
                statsViewStatus = .hasData
                groupName = response.groupInfo.name
                endDate = response.groupInfo.endAt
                maximumMemberCount = response.groupInfo.maximumMemberCount
                currentMemberCount = response.groupInfo.currentMemberCount
                joinCode = response.groupInfo.joinCode
                
                myRank = response.ranking.myRank
                totalMembers = response.ranking.totalMemberCount
                statsSummary = response.stats
                dailyAchievements = response.certificationPeriods
                
                delegate?.didFetchStatsSucceed()
            } catch {
                statsViewStatus = .empty
                throw error
            }
        }
    }
    
    /// 첫 진입시 참여중인 그룹정보 전체조회
    func fetchMyGroups() {
        Task {
            do {
                let (groupIndex, challengeGroupInfos) = try await groupUseCase.getChallengeGroupInfos()
                groups = challengeGroupInfos
                
                // GroupSortOption 배열로 변환
                self.groupSortOptions = groups.map {
                    GroupSortOption(groupId: $0.id, groupName: $0.name)
                }
                
                if groups.isEmpty {
                    statsViewStatus = .empty
                } else if let currentGroupIndex = groupIndex {
                    let currentGroup = groups[currentGroupIndex]
                    selectedGroup = GroupSortOption(groupId: currentGroup.id, groupName: currentGroup.name)
                    fetchStats(groupId: currentGroup.id)
                }
            } catch let error as NetworkError {                
                delegate?.didFetchStatsFail(error: error)
            }
        }
    }
    
    /// 특정 그룹 선택 후 해당그룹 정보조회
    func fetchStatsForSelectedGroup(_ option: GroupSortOption) {
        selectedGroup = option
        fetchStats(groupId: option.groupId)
    }
}
