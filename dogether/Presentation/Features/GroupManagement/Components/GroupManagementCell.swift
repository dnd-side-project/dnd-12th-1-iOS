//
//  GroupManagementCell.swift
//  dogether
//
//  Created by yujaehong on 4/22/25.
//

import UIKit
import SnapKit

final class GroupManagementCell: BaseTableViewCell, ReusableProtocol {

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey800
        view.layer.cornerRadius = 12
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.head2B
        label.textColor = .grey100
        return label
    }()

    private let memberTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "그룹원"
        label.font = Fonts.smallR
        label.textColor = .grey300
        return label
    }()

    private let memberValueLabel: UILabel = {
        let label = UILabel()
        label.text = "" // 없애기
        label.font = Fonts.smallR
        label.textColor = .grey100
        return label
    }()

    private let dateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "종료일"
        label.font = Fonts.smallR
        label.textColor = .grey300
        return label
    }()

    private let dateValueLabel: UILabel = {
        let label = UILabel()
        label.text = "" // 없애기
        label.font = Fonts.smallR
        label.textColor = .grey100
        return label
    }()

    private let codeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "초대코드"
        label.font = Fonts.smallR
        label.textColor = .grey300
        return label
    }()

    private let codeValueLabel: UILabel = {
        let label = UILabel()
        label.text = "" // 없애기
        label.font = Fonts.smallR
        label.textColor = .grey100
        return label
    }()

    private let leaveButton: UIButton = {
        let button = UIButton()
        button.setTitle("탈퇴하기", for: .normal)
        button.setTitleColor(.grey100, for: .normal)
        button.backgroundColor = .grey700
        button.titleLabel?.font = Fonts.body2S
        button.layer.cornerRadius = 6
        return button
    }()

    var onLeaveButtonTapped: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configureView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
    }

    override func configureAction() {
        leaveButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                onLeaveButtonTapped?()
                print("탈퇴하기 버튼 Tapped")
            },
            for: .touchUpInside
        )
    }

    override func configureHierarchy() {
        contentView.addSubview(containerView)

        containerView.addSubview(titleLabel)
        containerView.addSubview(memberTitleLabel)
        containerView.addSubview(memberValueLabel)
        containerView.addSubview(dateTitleLabel)
        containerView.addSubview(dateValueLabel)
        containerView.addSubview(leaveButton)
        containerView.addSubview(codeTitleLabel)
        containerView.addSubview(codeValueLabel)
    }

    override func configureConstraints() {
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(8)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().inset(16)
        }

        memberTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(16)
        }

        memberValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(memberTitleLabel)
            $0.leading.equalTo(memberTitleLabel.snp.trailing).offset(4)
        }

        dateTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(memberTitleLabel)
            $0.leading.equalTo(memberValueLabel.snp.trailing).offset(20)
        }

        dateValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(dateTitleLabel)
            $0.leading.equalTo(dateTitleLabel.snp.trailing).offset(4)
        }

        leaveButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(72)
            $0.height.equalTo(28)
        }

        codeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(memberTitleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(12)
        }

        codeValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(codeTitleLabel)
            $0.leading.equalTo(codeTitleLabel.snp.trailing).offset(4)
        }
    }
}

extension GroupManagementCell {
    func configure(with group: ChallengeGroup) {
        titleLabel.text = group.groupName
        memberValueLabel.text = "\(group.currentMemberCount)/\(group.maximumMemberCount)"
        dateValueLabel.text = group.endAt
        codeValueLabel.text = group.joinCode
    }
}
