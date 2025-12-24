//
//  GroupManagementCell.swift
//  dogether
//
//  Created by yujaehong on 4/22/25.
//

import UIKit
import SnapKit

final class GroupManagementCell: BaseTableViewCell {
    var delegate: GroupManagementDelegate? {
        didSet {
            leaveButton.addAction(
                UIAction { [weak self] _ in
                    guard let self, let currentGroup else { return }
                    delegate?.leaveGroupAction(currentGroup)
                },
                for: .touchUpInside
            )
        }
    }
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let memberTitleLabel = UILabel()
    private let memberValueLabel = UILabel()
    private let dateTitleLabel = UILabel()
    private let dateValueLabel = UILabel()
    private let codeTitleLabel = UILabel()
    private let codeValueLabel = UILabel()
    private let leaveButton = UIButton()
    
    private(set) var currentGroup: GroupEntity?

    override func configureView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        containerView.backgroundColor = .grey800
        containerView.layer.cornerRadius = 12
        
        titleLabel.font = Fonts.head2B
        titleLabel.textColor = .grey0
        
        memberTitleLabel.text = "그룹원"
        dateTitleLabel.text = "종료일"
        codeTitleLabel.text = "초대코드"
        
        [memberTitleLabel, dateTitleLabel, codeTitleLabel].forEach { titleLabel in
            titleLabel.font = Fonts.smallR
            titleLabel.textColor = .grey200
        }
        
        [memberValueLabel, dateValueLabel, codeValueLabel].forEach { valueLabel in
            valueLabel.font = Fonts.smallR
            valueLabel.textColor = .grey0
        }
        
        leaveButton.setTitle("탈퇴하기", for: .normal)
        leaveButton.setTitleColor(.grey0, for: .normal)
        leaveButton.backgroundColor = .grey700
        leaveButton.titleLabel?.font = Fonts.body2S
        leaveButton.layer.cornerRadius = 6
    }

    override func configureAction() { }

    override func configureHierarchy() {
        contentView.addSubview(containerView)

        [ titleLabel, leaveButton,
          memberTitleLabel, memberValueLabel, dateTitleLabel, dateValueLabel,
          codeTitleLabel, codeValueLabel].forEach { containerView.addSubview($0) }
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
    
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? GroupEntity {
            if currentGroup != datas {
                currentGroup = datas
                
                titleLabel.text = datas.name
                memberValueLabel.text = "\(datas.currentMember)/\(datas.maximumMember)"
                dateValueLabel.text = datas.endDate
                codeValueLabel.text = datas.joinCode
            }
        }
    }
}
