//
//  DogetherGroupInfo.swift
//  dogether
//
//  Created by seungyooooong on 2/10/25.
//

import UIKit

final class DogetherGroupInfo: BaseView {
    var groupName: String
    var memberCount: Int
    var duration: GroupChallengeDurations
    var startAt: GroupStartAts?
    var startAtString: String?
    var endAtString: String?
    
    init(
        groupName: String = "",
        memberCount: Int = 0,
        duration: GroupChallengeDurations = .threeDays,
        startAt: GroupStartAts = .today
    ) {
        self.groupName = groupName
        self.memberCount = memberCount
        self.duration = duration
        self.startAt = startAt
        
        super.init(frame: .zero)
    }
    init(
        groupName: String = "",
        memberCount: Int = 0,
        duration: Int = 3,
        startAtString: String,
        endAtString: String
    ) {
        self.groupName = groupName
        self.memberCount = memberCount
        self.duration = GroupChallengeDurations(rawValue: duration) ?? .threeDays
        self.startAtString = startAtString
        self.endAtString = endAtString
        
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let groupInfoView = {
        let view = UIView()
        view.backgroundColor = .grey700
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let groupNameLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.font = Fonts.head1B
        return label
    }()
    
    private let dividerView = {
        let view = UIView()
        view.backgroundColor = .grey600
        return view
    }()
    
    private func descriptionLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .blue300
        label.font = Fonts.body1B
        return label
    }
    
    private func infoLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .grey200
        label.font = Fonts.body1R
        return label
    }
    
    private var durationDescriptionLabel = UILabel()
    private var memberCountDescriptionLabel = UILabel()
    private var startDayDescriptionLabel = UILabel()
    private var endDayDescriptionLabel = UILabel()
    
    private var durationInfoLabel = UILabel()
    private var memberCountInfoLabel = UILabel()
    private var startDayInfoLabel = UILabel()
    private var endDayInfoLabel = UILabel()
    
    override func configureView() {
        durationDescriptionLabel = descriptionLabel()
        memberCountDescriptionLabel = descriptionLabel()
        startDayDescriptionLabel = descriptionLabel()
        endDayDescriptionLabel = descriptionLabel()
        
        durationInfoLabel = infoLabel()
        memberCountInfoLabel = infoLabel()
        startDayInfoLabel = infoLabel()
        endDayInfoLabel = infoLabel()
        
        groupNameLabel.text = groupName
        
        durationDescriptionLabel.text = "활동 기간"
        memberCountDescriptionLabel.text = "그룹원"
        startDayDescriptionLabel.text = "시작일"
        endDayDescriptionLabel.text = "종료일"
        
        durationInfoLabel.text = duration.text
        memberCountInfoLabel.text = "총 \(memberCount)명"
        if let startAtString, let endAtString {
            startDayInfoLabel.text = "\(startAtString)"
            endDayInfoLabel.text = "\(endAtString)"
        }
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [ groupInfoView,
          durationDescriptionLabel, memberCountDescriptionLabel, startDayDescriptionLabel, endDayDescriptionLabel,
          durationInfoLabel, memberCountInfoLabel, startDayInfoLabel, endDayInfoLabel
        ].forEach { addSubview($0) }
        
        [groupNameLabel, dividerView].forEach { groupInfoView.addSubview($0) }
    }
    
    override func configureConstraints() {
        groupInfoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        groupNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(24)
            $0.height.equalTo(36)
        }
        
        dividerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(groupNameLabel.snp.bottom).offset(24)
            $0.height.equalTo(1)
        }
        
        durationDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(24)
            $0.left.equalTo(dividerView)
            $0.height.equalTo(25)
        }
        
        memberCountDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(durationDescriptionLabel.snp.bottom).offset(12)
            $0.left.equalTo(durationDescriptionLabel)
            $0.height.equalTo(25)
        }
        
        startDayDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(memberCountDescriptionLabel.snp.bottom).offset(12)
            $0.left.equalTo(memberCountDescriptionLabel)
            $0.height.equalTo(25)
        }
        
        endDayDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(startDayDescriptionLabel.snp.bottom).offset(12)
            $0.left.equalTo(startDayDescriptionLabel)
            $0.height.equalTo(25)
        }
        
        durationInfoLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(24)
            $0.right.equalTo(dividerView)
            $0.height.equalTo(25)
        }
        
        memberCountInfoLabel.snp.makeConstraints {
            $0.top.equalTo(durationInfoLabel.snp.bottom).offset(12)
            $0.right.equalTo(durationInfoLabel)
            $0.height.equalTo(25)
        }
        
        startDayInfoLabel.snp.makeConstraints {
            $0.top.equalTo(memberCountInfoLabel.snp.bottom).offset(12)
            $0.right.equalTo(memberCountInfoLabel)
            $0.height.equalTo(25)
        }
        
        endDayInfoLabel.snp.makeConstraints {
            $0.top.equalTo(startDayInfoLabel.snp.bottom).offset(12)
            $0.right.equalTo(startDayInfoLabel)
            $0.height.equalTo(25)
        }
    }
}
 
extension DogetherGroupInfo {
    func setInfo(groupName: String, memberCount: Int, duration: GroupChallengeDurations, startAt: GroupStartAts) {
        self.groupName = groupName
        self.memberCount = memberCount
        self.duration = duration
        self.startAt = startAt
        
        
        groupNameLabel.text = groupName
        durationInfoLabel.text = duration.text
        memberCountInfoLabel.text = "총 \(memberCount)명"
        startDayInfoLabel.text = DateFormatterManager.formattedDate(startAt.daysFromToday)
        endDayInfoLabel.text = DateFormatterManager.formattedDate(startAt.daysFromToday + duration.rawValue)
    }
}
