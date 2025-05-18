//
//  StartViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/9/25.
//

import UIKit
import SnapKit

final class StartViewController: BaseViewController {
    var isFirst = true  // FIXME: 추후 수정
    
    private let dogetherHeader = DogetherHeader()
    
    private let navigationHeader = NavigationHeader(title: "새 그룹 추가")
    
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
    
    private func startButton(groupType: GroupTypes) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .grey800
        button.layer.cornerRadius = 12
        button.tag = groupType.rawValue
        button.addAction(
            UIAction { [weak self, weak button] _ in
                guard let self, let button, let groupType = GroupTypes(rawValue: button.tag) else { return }
                coordinator?.pushViewController(groupType.destination)
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
    private var createButton = UIButton()
    private var joinButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        dogetherHeader.delegate = self
        
        navigationHeader.delegate = self
        
        createButton = startButton(groupType: .create)
        joinButton = startButton(groupType: .join)
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        if isFirst { [dogetherHeader, titleLabel].forEach { view.addSubview($0) } }
        else { [navigationHeader].forEach { view.addSubview($0) } }
        
        [createButton, joinButton].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        if isFirst {
            dogetherHeader.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide)
                $0.horizontalEdges.equalToSuperview()
            }
            
            titleLabel.snp.makeConstraints {
                $0.top.equalTo(dogetherHeader.snp.bottom).offset(28)
                $0.horizontalEdges.equalToSuperview().inset(16)
                $0.height.equalTo(72)
            }
        } else {
            navigationHeader.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide)
                $0.horizontalEdges.equalToSuperview()
            }
        }
        
        createButton.snp.makeConstraints {
            if isFirst {
                $0.top.equalTo(titleLabel.snp.bottom).offset(41)
            } else {
                $0.top.equalTo(navigationHeader.snp.bottom).offset(16)
            }
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(100)
        }
        
        joinButton.snp.makeConstraints {
            $0.top.equalTo(createButton.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(100)
        }
    }
}
