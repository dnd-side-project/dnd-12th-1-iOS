//
//  CompleteViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/12/25.
//

import Foundation
import UIKit
import SnapKit

final class CompleteViewController: BaseViewController {
    private let groupType: GroupTypes
    
    var viewModel = CompleteViewModel()
    
    private let firecrackerImageView = {
        let imageView = UIImageView()
        imageView.image = .firecracker
        return imageView
    }()
    private let titleLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let completeButton = DogetherButton(title: "홈으로 가기", status: .enabled)
    private var groupInfoView = UIView()
    private let joinCodeShareButton = {
        let button = UIButton()
        button.backgroundColor = .grey700
        button.layer.cornerRadius = 12
        return button
    }()
    private let joinCodeLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.font = Fonts.head1B
        label.isUserInteractionEnabled = false
        return label
    }()
    private let joinCodeImageView = {
        let imageView = UIImageView()
        imageView.image = .share.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .grey400
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    private let noticeLabel = {
        let label = UILabel()
        label.textColor = .grey400
        label.font = Fonts.body2R
        label.numberOfLines = 0
        return label
    }()
    private let noticeImageView = {
        let imageView = UIImageView()
        imageView.image = .notice
        return imageView
    }()

    // TODO: 추후 초대 코드 또는 그룹 정보를 포함하도록 수정
    override init(type: GroupTypes) {
        self.groupType = type
        super.init()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        titleLabel.attributedText = NSAttributedString(
            string: groupType.completeTitleText,
            attributes: Fonts.getAttributes(for: Fonts.head1B, textAlignment: .center)
        )
        completeButton.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
        // TODO: 추후 수정
        switch groupType {
        case .join:
            guard let groupInfo = viewModel.joinGroupResponse else { return }
            groupInfoView = DogetherGroupInfo(
                groupName: groupInfo.name,
                memberCount: groupInfo.maximumMemberCount,
                duration: GroupChallengeDurations(rawValue: groupInfo.durationOption) ?? .threeDays,
                startAtString: groupInfo.startAt,
                endAtString: groupInfo.endAt
            )
        case .create:
            noticeLabel.text = groupType.completeNoticeText
            joinCodeLabel.text = viewModel.joinCode
            joinCodeShareButton.addTarget(self, action: #selector(didTapJoinCodeShareButton), for: .touchUpInside)
        }
    }
    
    override func configureHierarchy() {
        [firecrackerImageView, titleLabel, completeButton].forEach { view.addSubview($0) }
        switch groupType {
        case .join:
            [groupInfoView].forEach { view.addSubview($0) }
        case .create:
            [joinCodeShareButton, joinCodeLabel, joinCodeImageView, noticeLabel, noticeImageView].forEach { view.addSubview($0) }
        }
    }
    
    override func configureConstraints() {
        firecrackerImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(68)
            $0.width.height.equalTo(40)
        }
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(firecrackerImageView.snp.bottom).offset(20)
            $0.height.equalTo(72)
        }
        completeButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(48)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        switch groupType {
        case .join:
            groupInfoView.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(40)
                $0.horizontalEdges.equalToSuperview().inset(36)
                $0.height.equalTo(269)
            }
        case .create:
            joinCodeShareButton.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(68)
                $0.horizontalEdges.equalToSuperview().inset(36)
                $0.height.equalTo(75)
            }
            joinCodeLabel.snp.makeConstraints {
                $0.centerX.equalTo(joinCodeShareButton).offset(-17)
                $0.centerY.equalTo(joinCodeShareButton)
            }
            joinCodeImageView.snp.makeConstraints {
                $0.centerY.equalTo(joinCodeShareButton)
                $0.left.equalTo(joinCodeLabel.snp.right).offset(10)
                $0.width.height.equalTo(24)
            }
            noticeLabel.snp.makeConstraints {
                $0.centerX.equalToSuperview().offset(12)
                $0.top.equalTo(joinCodeShareButton.snp.bottom).offset(16)
                $0.height.equalTo(21)
            }
            noticeImageView.snp.makeConstraints {
                $0.top.equalTo(noticeLabel)
                $0.right.equalTo(noticeLabel.snp.left).offset(-4)
                $0.width.height.equalTo(20)
            }
        }
    }
    
    @objc private func didTapCompleteButton() {
        NavigationManager.shared.setNavigationController(MainViewController())
    }
    
    @objc private func didTapJoinCodeShareButton() {
        // TODO: 추후 수정
        present(UIActivityViewController(activityItems: [viewModel.joinCode], applicationActivities: nil), animated: true)
    }
}
