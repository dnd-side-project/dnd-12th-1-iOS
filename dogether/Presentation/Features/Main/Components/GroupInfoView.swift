//
//  GroupInfoView.swift
//  dogether
//
//  Created by seungyooooong on 3/8/25.
//

import UIKit

final class GroupInfoView: BaseView {
    private let hasCopyImage: Bool
    private(set) var challengeGroupInfo: ChallengeGroupInfo
    
    init(challengeGroupInfo: ChallengeGroupInfo = ChallengeGroupInfo(), hasCopyImage: Bool = true) {
        self.challengeGroupInfo = challengeGroupInfo
        self.hasCopyImage = hasCopyImage
        
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let nameLabel = {
        let label = UILabel()
        label.textColor = .blue300
        label.font = Fonts.head1B
        return label
    }()
    
    private let changeGroupImageView = UIImageView(image: .chevronDown)
    
    // MARK: 탭 액션 viewController에서 지정
    let groupNameStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()
    
    private let memberInfoLabel = UILabel()
    private let joinCodeInfoLabel = UILabel()
    private let endDateInfoLabel = UILabel()
    
    private let joinCodeCopyImageView = UIImageView(image: .copy)
    private let joinCodeInfoStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .bottom
        return stackView
    }()
    
    private var memberStackView = UIStackView()
    var joinCodeStackView = UIStackView()   // MARK: 탭 액션 viewController에서 지정
    private var endDateStackView = UIStackView()
    private func infoStackView(description: String) -> UIStackView {
        let label = UILabel()
        label.attributedText = NSAttributedString(
            string: description,
            attributes: Fonts.getAttributes(for: Fonts.body2R, textAlignment: .left)
        )
        label.textColor = .grey300
        
        let stackView = UIStackView(arrangedSubviews: [label])
        stackView.axis = .vertical
        
        return stackView
    }
    
    let groupInfoStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()
    
    // TODO: 추후 Label 전체 개선 시 다른 descriptionLabel들과 통일하도록 수정
    private let durationDescriptionLabel = {
        let label = UILabel()
        label.text = "진행 현황"
        label.textColor = .grey300
        label.font = Fonts.body2R
        return label
    }()
    
    private let durationInfoLabel = {
        let label = UILabel()
        label.textColor = .grey300
        label.font = Fonts.smallR
        return label
    }()
    
    private let durationProgressView = {
        let progressView = UIProgressView()
        progressView.layer.cornerRadius = 4
        progressView.clipsToBounds = true
        progressView.trackTintColor = .grey800
        progressView.progressTintColor = .blue300
        
        if let progressLayer = progressView.subviews.last {
            progressLayer.layer.cornerRadius = 4
            progressLayer.clipsToBounds = true
        }
        
        return progressView
    }()
    
    let durationStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    override func configureView() {
        updateUI()
        
        [nameLabel, changeGroupImageView].forEach { groupNameStackView.addArrangedSubview($0) }
        
        memberStackView = infoStackView(description: "그룹원")
        joinCodeStackView = infoStackView(description: "초대코드")
        endDateStackView = infoStackView(description: "종료일")
        
        memberInfoLabel.textColor = .grey0
        joinCodeInfoLabel.textColor = .grey0
        endDateInfoLabel.textColor = .grey0
        
        memberStackView.addArrangedSubview(memberInfoLabel)
        if hasCopyImage { [joinCodeInfoLabel, joinCodeCopyImageView].forEach { joinCodeInfoStackView.addArrangedSubview($0) } }
        joinCodeStackView.addArrangedSubview(hasCopyImage ? joinCodeInfoStackView : joinCodeInfoLabel)
        endDateStackView.addArrangedSubview(endDateInfoLabel)
        
        [memberStackView, joinCodeStackView, endDateStackView].forEach { groupInfoStackView.addArrangedSubview($0) }
        
        [durationDescriptionLabel, durationInfoLabel, durationProgressView].forEach { durationStackView.addArrangedSubview($0) }
        durationStackView.setCustomSpacing(2, after: durationDescriptionLabel)
        durationStackView.setCustomSpacing(11, after: durationInfoLabel)
        
        durationProgressView.transform = CGAffineTransform(translationX: 0, y: 1)   // MARK: 디자인 디테일 반영
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [groupNameStackView, groupInfoStackView, durationStackView].forEach { self.addSubview($0) }
    }
    
    override func configureConstraints() {
        groupNameStackView.snp.makeConstraints {
            $0.top.left.equalToSuperview()
            $0.height.equalTo(36)
        }
        
        changeGroupImageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        
        groupInfoStackView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(12)
            $0.left.equalToSuperview()
        }
        
        joinCodeCopyImageView.snp.makeConstraints {
            $0.width.height.equalTo(18)
        }
        
        durationProgressView.snp.makeConstraints {
            $0.height.equalTo(8)
        }
        
        durationStackView.snp.makeConstraints {
            $0.top.equalTo(groupInfoStackView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(21)
        }
    }
}
 
extension GroupInfoView {
    private func updateUI() {
        nameLabel.text = challengeGroupInfo.name
        
        memberInfoLabel.attributedText = NSAttributedString(
            string: "\(challengeGroupInfo.currentMember)/\(challengeGroupInfo.maximumMember)",
            attributes: Fonts.getAttributes(for: Fonts.body1S, textAlignment: .left)
        )
        joinCodeInfoLabel.attributedText = NSAttributedString(
            string: challengeGroupInfo.joinCode,
            attributes: Fonts.getAttributes(for: Fonts.body1S, textAlignment: .left)
        )
        endDateInfoLabel.attributedText = NSAttributedString(
            string: challengeGroupInfo.endDate,
            attributes: Fonts.getAttributes(for: Fonts.body1S, textAlignment: .left)
        )
        
        durationInfoLabel.text = "(\(challengeGroupInfo.duration)일차)" // FIXME: API 수정 후 변경
        durationProgressView.progress = challengeGroupInfo.progress
    }
    
    func setChallengeGroupInfo(challengeGroupInfo: ChallengeGroupInfo) {
        self.challengeGroupInfo = challengeGroupInfo
        
        updateUI()
    }
}
