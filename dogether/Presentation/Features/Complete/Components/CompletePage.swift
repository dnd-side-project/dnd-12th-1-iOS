//
//  CompletePage.swift
//  dogether
//
//  Created by yujaehong on 10/26/25.
//

import UIKit

final class CompletePage: BasePage {
    weak var delegate: CompleteDelegate? {
        didSet {
            completeButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.goHomeAction()
                },
                for: .touchUpInside
            )
            
            joinCodeShareButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.shareJoinCodeAction()
                },
                for: .touchUpInside
            )
        }
    }

    private let firecrackerImageView = UIImageView(image: .firecracker)
    private let titleLabel = UILabel()
    private let completeButton = DogetherButton("홈으로 가기")
    private let groupInfoView = DogetherGroupInfo()
    private let joinCodeShareButton  = JoinCodeShareButton()

    private let noticeView = {
        let imageView = UIImageView(image: .notice)
        let label = UILabel()
        label.text = "카카오톡, 문자 등을 통해 공유해보세요 !"
        label.textColor = .grey400
        label.font = Fonts.body2R

        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .horizontal
        stackView.spacing = 4
        imageView.snp.makeConstraints { $0.width.height.equalTo(20) }
        return stackView
    }()

    override func configureView() {
        titleLabel.textColor = .grey0
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
    }

    override func configureAction() {
    }

    override func configureHierarchy() {
        [firecrackerImageView, titleLabel, completeButton,
         groupInfoView, joinCodeShareButton, noticeView
        ].forEach { addSubview($0) }
    }

    override func configureConstraints() {
        firecrackerImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(68)
            $0.width.height.equalTo(40)
        }

        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(firecrackerImageView.snp.bottom).offset(20)
            $0.height.equalTo(72)
        }

        completeButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        groupInfoView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(36)
            $0.height.equalTo(269)
        }
        
        joinCodeShareButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(68)
            $0.horizontalEdges.equalToSuperview().inset(36)
            $0.height.equalTo(75)
        }
        
        noticeView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(joinCodeShareButton.snp.bottom).offset(16)
        }
    }
    
    override func updateView(_ data: (any BaseEntity)?) {
        guard let datas = data as? CompleteViewDatas else { return }
        
        // FIXME: 추후 수정
        let dogetherButtonViewDatas = completeButton.currentViewDatas ?? DogetherButtonViewDatas()
        completeButton.updateView(dogetherButtonViewDatas)
        
        titleLabel.attributedText = NSAttributedString(
            string: datas.groupType.completeTitleText,
            attributes: Fonts.getAttributes(for: Fonts.head1B, textAlignment: .center)
        )
        
        switch datas.groupType {
        case .join:
            let viewData = DogetherGroupInfoViewData(
                name: datas.groupInfo.name,
                memberCount: datas.groupInfo.maximumMember,
                duration: GroupChallengeDurations(rawValue: datas.groupInfo.duration) ?? .threeDays,    // FIXME: 추후 수정
                startDay: datas.groupInfo.startDate,
                endDay: datas.groupInfo.endDate
            )
            
            groupInfoView.updateView(viewData)
            
            groupInfoView.isHidden = false
            joinCodeShareButton.isHidden = true
            noticeView.isHidden = true
            
        case .create:
            joinCodeShareButton.updateView(
                JoinCodeShareButtonViewData(joinCode: datas.joinCode)
            )
            
            groupInfoView.isHidden = true
            joinCodeShareButton.isHidden = false
            noticeView.isHidden = false
        }
    }
}
