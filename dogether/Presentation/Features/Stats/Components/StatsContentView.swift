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
    
    private let dosikImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .glassDosik
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = false
        return imageView
    }()
    
    private let dosikArmView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .dosikArm
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
        let groupSelectorTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedGroupSelectorStackView))
        groupInfoView.groupSelectorStackView.addGestureRecognizer(groupSelectorTapGesture)
    }
    
    override func configureHierarchy() {
        addSubview(dosikImageView)
        addSubview(groupInfoView)
        addSubview(dailyAchievementBarView)
        addSubview(dosikArmView)
        addSubview(myRankView)
        addSubview(statsSummaryView)
    }
    
    override func configureConstraints() {
        groupInfoView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(94)
        }
        
        dosikImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(23.7)
            $0.trailing.equalToSuperview().inset(24)
            $0.width.equalTo(100)
            $0.height.equalTo(126)
        }
        
        dosikArmView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(95.53)
            $0.trailing.equalToSuperview().inset(27.07)
            $0.width.equalTo(91.5)
            $0.height.equalTo(28.4)
        }
        
        dailyAchievementBarView.snp.makeConstraints {
            $0.top.equalTo(groupInfoView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(343)
        }
        
        myRankView.snp.makeConstraints {
            $0.top.equalTo(dailyAchievementBarView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(180)
        }

        statsSummaryView.snp.makeConstraints {
            $0.top.equalTo(dailyAchievementBarView.snp.bottom).offset(16)
            $0.leading.equalTo(myRankView.snp.trailing).offset(18)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(myRankView.snp.width)
            $0.height.equalTo(180)
        }
    }
    
    @objc private func tappedGroupSelectorStackView() {
        delegate?.presentBottomSheet()
    }
}
