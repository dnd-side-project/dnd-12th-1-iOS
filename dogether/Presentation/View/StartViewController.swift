//
//  StartViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/9/25.
//

import Foundation
import UIKit
import SnapKit

final class StartViewController: BaseViewController {
    private let viewModel = StartViewModel()
    
    private let dogetherHeader = DogetherHeader()
    
    private let titleLabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(
            string: "소속된 그룹이 없어요.\n그룹을 만들거나 참여하세요!",
            attributes: Fonts.getAttributes(for: Fonts.head1B, textAlignment: .left)
        )
        label.textColor = .grey0
        label.numberOfLines = 0
        return label
    }()
    
    private let floatingDescription = {
        let button = UIButton()
        button.backgroundColor = .grey50
        button.layer.cornerRadius = 8
        button.layer.zPosition = 1
        
        let tail = UIImageView(image: .tail)
        
        let label = UILabel()
        label.text = "한 번에 하나의 그룹에서만 활동할 수 있어요"
        label.textColor = .grey800
        label.font = Fonts.smallS
        
        let icon = UIImageView(image: .close)
        icon.contentMode = .scaleAspectFit
        
        let stackView = UIStackView(arrangedSubviews: [label, icon])
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.isUserInteractionEnabled = false
        
        [tail, stackView].forEach { button.addSubview($0) }
        
        tail.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-7)
            $0.left.equalToSuperview().offset(25)
            $0.width.height.equalTo(14)
        }
        
        label.snp.makeConstraints {
            $0.height.equalTo(18)
        }
        
        icon.snp.makeConstraints {
            $0.width.equalTo(12)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
        
        return button
    }()
    
    private func startButton(groupType: GroupTypes) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .grey800
        button.layer.cornerRadius = 12
        button.tag = groupType.rawValue
        button.addTarget(self, action: #selector(didTapStartButton(_:)), for: .touchUpInside)
        
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
    private var createButton = UIButton()
    private var joinButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        floatingDescription.addTarget(self, action: #selector(didTapFloatingDescription), for: .touchUpInside)
        
        createButton = startButton(groupType: .create)
        joinButton = startButton(groupType: .join)
    }
    
    override func configureHierarchy() {
        [dogetherHeader, titleLabel, floatingDescription, createButton, joinButton].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        dogetherHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(28)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(dogetherHeader.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(72)
        }
        
        floatingDescription.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.left.equalTo(titleLabel)
        }
        
        createButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(41)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(100)
        }
        
        joinButton.snp.makeConstraints {
            $0.top.equalTo(createButton.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(100)
        }
    }
    
    @objc private func didTapFloatingDescription() {
        viewModel.hideFloating(completeAction: updateView)
    }
    
    @objc private func didTapStartButton(_ sender: UIButton) {
        viewModel.navigate(destinationTag: sender.tag)
    }
}

// MARK: - update UI
extension StartViewController {
    private func updateView() {
        floatingDescription.isHidden = !viewModel.isShowFloating
    }
}
