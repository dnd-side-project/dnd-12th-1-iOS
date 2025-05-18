//
//  StatsGroupInfoView.swift
//  dogether
//
//  Created by yujaehong on 5/2/25.
//

import UIKit
import SnapKit

final class StatsGroupInfoView: UIView {
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
        button.setImage(UIImage(named: "chevron-down"), for: .normal)
        return button
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
    
    private lazy var memberStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [memberTitleLabel, memberDataLabel])
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
    
    private lazy var joinCodeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [joinCodeTitleLabel, joinCodeLabel])
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
    
    private lazy var endDateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [endDateTitleLabel, endDateLabel])
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [memberStackView, joinCodeStackView, endDateStackView])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    var onGroupSelectorTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        backgroundColor = .clear
        addSubview(groupNameLabel)
        addSubview(groupSelectorButton)
        addSubview(infoStackView)
        
        groupSelectorButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                onGroupSelectorTapped?()
            }, for: .touchUpInside
        )
    }
    
    private func setupConstraints() {
        groupNameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        groupSelectorButton.snp.makeConstraints {
            $0.centerY.equalTo(groupNameLabel) // groupNameLabel과 세로 중심 맞추기
            $0.leading.equalTo(groupNameLabel.snp.trailing).offset(4) // groupNameLabel의 trailing으로부터 4pt 떨어지게 설정
            $0.width.height.equalTo(20) // 크기 고정
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
