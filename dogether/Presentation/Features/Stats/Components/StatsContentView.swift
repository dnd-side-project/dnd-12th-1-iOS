//
//  StatsContentView.swift
//  dogether
//
//  Created by yujaehong on 4/23/25.
//

import UIKit

final class StatsContentView: BaseView {
    weak var delegate: BottomSheetDelegate?
    
    private let viewModel: StatsViewModel
    private let groupInfoView = StatsGroupInfoView()
    private let dailyAchievementBarView = DailyAchievementBarView()
    private let myRankView = MyRankView()
    private let statsSummaryView = StatsSummaryView()
    
    private let dusikImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "glassDusik")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = false
        return imageView
    }()
    
    private let dusikArmView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dusikArm")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = false
        return imageView
    }()
    
    init(viewModel: StatsViewModel) {
        self.viewModel = viewModel
        self.dailyAchievementBarView.configure(achievements: viewModel.dailyAchievements)
        self.myRankView.configure(count: viewModel.totalMembers,
                                  rank: viewModel.myRank)
        self.statsSummaryView.configure(certificatedCount: viewModel.statsSummary?.certificatedCount ?? 0,
                                        approvedCount: viewModel.statsSummary?.approvedCount ?? 0,
                                        rejectedCount: viewModel.statsSummary?.rejectedCount ?? 0)
        self.groupInfoView.configure(groupName: viewModel.groupName,
                                     currentMemberCount: viewModel.currentMemberCount,
                                     maximumMemberCount: viewModel.maximumMemberCount,
                                     joinCode: viewModel.joinCode,
                                     endDate: viewModel.endDate)
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func configureView() {
        backgroundColor = .clear
    }
    
    override func configureAction() {
        groupInfoView.onGroupSelectorTapped = { [weak self] in
            guard let self else { return }
            delegate?.presentBottomSheet()
        }
    }
    
    override func configureHierarchy() {
        addSubview(dusikImageView)
        addSubview(groupInfoView)
        addSubview(dailyAchievementBarView)
        addSubview(dusikArmView)
        addSubview(myRankView)
        addSubview(statsSummaryView)
    }
    
    override func configureConstraints() {
        groupInfoView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(94)
        }
        
        dusikImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(23.7)
            $0.trailing.equalToSuperview().inset(24)
            $0.width.equalTo(100)
            $0.height.equalTo(126)
        }
        
        dusikArmView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(95.53)
            $0.trailing.equalToSuperview().inset(27.07)
            $0.width.equalTo(91.5)
            $0.height.equalTo(28.4)
        }
        
        dailyAchievementBarView.snp.makeConstraints {
            $0.top.equalTo(groupInfoView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(343)
        }
        
        myRankView.snp.makeConstraints {
            $0.top.equalTo(dailyAchievementBarView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(180)
        }

        statsSummaryView.snp.makeConstraints {
            $0.top.equalTo(dailyAchievementBarView.snp.bottom).offset(16)
            $0.leading.equalTo(myRankView.snp.trailing).offset(18) // 두 뷰 사이 간격 18
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(myRankView.snp.width) // 너비 동일하게
            $0.height.equalTo(180)
        }
    }
}
