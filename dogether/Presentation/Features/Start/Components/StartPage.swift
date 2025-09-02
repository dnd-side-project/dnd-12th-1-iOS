//
//  StartPage.swift
//  dogether
//
//  Created by seungyooooong on 8/11/25.
//

import UIKit

final class StartPage: BasePage {
    var delegate: StartDelegate?
    
    private let dogetherHeader = DogetherHeader()
    private let navigationHeader = NavigationHeader(title: "새 그룹 추가")
    private let titleLabel = UILabel()
    private let buttonStackView = UIStackView()
    
    private let startButtonHeight: CGFloat = 100
    private let buttonStackViewSpacing: CGFloat = 16
    private var buttonStackViewHeight: CGFloat {
        startButtonHeight * CGFloat(GroupTypes.allCases.count) + buttonStackViewSpacing
    }
    
    override func configureView() {
        navigationHeader.isHidden = true
        
        titleLabel.attributedText = NSAttributedString(
            string: "소속된 그룹이 없어요.\n그룹을 만들거나 참여하세요!",
            attributes: Fonts.getAttributes(for: Fonts.head1B, textAlignment: .left)
        )
        titleLabel.textColor = .grey0
        titleLabel.numberOfLines = 0
        
        buttonStackView.axis = .vertical
        buttonStackView.spacing = buttonStackViewSpacing
        buttonStackView.distribution = .fillEqually
        
        GroupTypes.allCases.forEach {
            buttonStackView.addArrangedSubview(startButton(groupType: $0))
        }
    }
    
    override func configureAction() {
        dogetherHeader.delegate = coordinatorDelegate
        
        navigationHeader.delegate = coordinatorDelegate
    }
    
    override func configureHierarchy() {
        [dogetherHeader, navigationHeader, titleLabel, buttonStackView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        dogetherHeader.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(dogetherHeader.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(72)
        }
    
        navigationHeader.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(41)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(buttonStackViewHeight)
        }
    }
    
    // MARK: - viewDidUpdate
    override func updateHierarchy(_ data: (any BaseEntity)?) {
        guard let datas = data as? StartViewDatas else { return }
        
        dogetherHeader.isHidden = !datas.isFirstGroup
        
        navigationHeader.isHidden = datas.isFirstGroup
        
        titleLabel.isHidden = !datas.isFirstGroup
    }
    
    override func updateConstraints(_ data: (any BaseEntity)?) {
        guard let datas = data as? StartViewDatas else { return }
        
        buttonStackView.snp.remakeConstraints {
            $0.top.equalTo(datas.isFirstGroup ? titleLabel.snp.bottom : navigationHeader.snp.bottom)
                .offset(datas.isFirstGroup ? 41 : 16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(buttonStackViewHeight)
        }
    }
}

// MARK: - private func
extension StartPage {
    private func startButton(groupType: GroupTypes) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .grey800
        button.layer.cornerRadius = 12
        button.tag = groupType.rawValue
        button.addAction(
            UIAction { [weak self, weak button] _ in
                guard let self, let button, let groupType = GroupTypes(rawValue: button.tag) else { return }
                delegate?.startAction(groupType.destination)
            }, for: .touchUpInside
        )
        
        let imageView = UIImageView(image: groupType.image)
        imageView.isUserInteractionEnabled = false
        
        let titleLabel = UILabel()
        titleLabel.text = groupType.startTitleText
        titleLabel.textColor = .grey0
        titleLabel.font = Fonts.head2B
        titleLabel.isUserInteractionEnabled = false
        
        let subTitleLabel = UILabel()
        subTitleLabel.text = groupType.startSubTitleText
        subTitleLabel.textColor = .grey400
        subTitleLabel.font = Fonts.body2R
        subTitleLabel.isUserInteractionEnabled = false
        
        let chevronImageView = UIImageView()
        chevronImageView.image = .chevronRight.withRenderingMode(.alwaysTemplate)
        chevronImageView.tintColor = .grey300
        chevronImageView.isUserInteractionEnabled = false
        
        [imageView, titleLabel, subTitleLabel, chevronImageView].forEach { button.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(22)
            $0.left.equalToSuperview().offset(16)
            $0.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalTo(imageView.snp.right).offset(8)
            $0.height.equalTo(28)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.equalTo(imageView)
            $0.height.equalTo(21)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-21)
            $0.width.height.equalTo(28)
        }
        
        return button
    }
}
