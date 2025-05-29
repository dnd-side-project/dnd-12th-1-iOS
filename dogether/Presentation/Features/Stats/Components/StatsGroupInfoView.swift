//
//  StatsGroupInfoView.swift
//  dogether
//
//  Created by yujaehong on 5/2/25.
//

import UIKit
import SnapKit

final class StatsGroupInfoView: BaseView {
    private let groupNameLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.head1B
        label.textColor = .blue300
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let groupSelectorButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(.chevronDown, for: .normal)
        return button
    }()
    
    let groupSelectorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()
    
    private let memberTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "그룹원"
        label.font = Fonts.body2R
        label.textColor = .grey300
        label.textAlignment = .left
        return label
    }()
    
    private let memberDataLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.body1S
        label.textColor = .grey0
        label.textAlignment = .left
        return label
    }()
    
    private let memberStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .leading
        return stackView
    }()
    
    private let joinCodeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "초대코드"
        label.font = Fonts.body2R
        label.textColor = .grey300
        label.textAlignment = .left
        return label
    }()
    
    private let joinCodeLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.body1S
        label.textColor = .grey0
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true // 줄임 방지
        label.minimumScaleFactor = 0.7
        return label
    }()
    
    private let joinCodeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .leading
        return stackView
    }()
    
    private let endDateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "종료일"
        label.font = Fonts.body2R
        label.textColor = .grey300
        label.textAlignment = .left
        return label
    }()
    
    private let endDateLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.body1S
        label.textColor = .grey0
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.lineBreakMode = .byTruncatingTail
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private let endDateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .leading
        return stackView
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    var onGroupSelectorTapped: (() -> Void)?
    
    override func configureView() {
        backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        [groupNameLabel, groupSelectorButton].forEach { groupSelectorStackView.addArrangedSubview($0) }
        [memberTitleLabel, memberDataLabel].forEach { memberStackView.addArrangedSubview($0) }
        [joinCodeTitleLabel, joinCodeLabel].forEach { joinCodeStackView.addArrangedSubview($0) }
        [endDateTitleLabel, endDateLabel].forEach { endDateStackView.addArrangedSubview($0) }
        [memberStackView, joinCodeStackView, endDateStackView].forEach { infoStackView.addArrangedSubview($0) }
        
        addSubview(groupSelectorStackView)
        addSubview(infoStackView)
    }
    
    override func configureConstraints() {
        groupSelectorStackView.snp.makeConstraints {
               $0.top.leading.equalToSuperview()
           }
        
        groupSelectorButton.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        
        infoStackView.snp.makeConstraints {
            $0.top.equalTo(groupNameLabel.snp.bottom).offset(12)
            $0.leading.bottom.equalToSuperview()
        }
    }
}

extension StatsGroupInfoView {
    func configure(groupName: String,
                   currentMemberCount: Int,
                   maximumMemberCount: Int,
                   joinCode: String,
                   endDate: String
    ) {
        groupNameLabel.text = groupName
        memberDataLabel.text = "\(currentMemberCount)/\(maximumMemberCount)"
        joinCodeLabel.text = joinCode
        endDateLabel.text = endDate
    }
}
