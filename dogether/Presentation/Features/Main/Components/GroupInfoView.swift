//
//  GroupInfoView.swift
//  dogether
//
//  Created by seungyooooong on 3/8/25.
//

import UIKit

enum GroupInfoTypes {
    case main
    case stats
    
    var groupNameTopOffset: CGFloat {
        switch self {
        case .main:
            6
        case .stats:
            0
        }
    }
}

final class GroupInfoView: BaseView {
    var mainDelegate: MainDelegate? {
        didSet {
            groupNameStackView.addTapAction { [weak self] _ in
                guard let self else { return }
                mainDelegate?.updateBottomSheetVisibleAction(isShowSheet: true)
            }
            
            joinCodeStackView.addTapAction { [weak self] _ in
                guard let self else { return }
                mainDelegate?.inviteAction()
            }
        }
    }
    
    var statsDelegate: StatsDelegate? {
        didSet {
            groupNameStackView.addTapAction { [weak self] _ in
                guard let self else { return }
                statsDelegate?.updateBottomSheetVisibleAction(isShowSheet: true)
            }
        }
    }
    
    private let type: GroupInfoTypes
    
    init(type: GroupInfoTypes) {
        self.type = type
        
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let dosikImageView = UIImageView(image: .noteDosik)
    
    private let nameLabel = UILabel()
    private let changeGroupImageView = UIImageView(image: .chevronDown)
    private let nameSpacerView = UIView()
    
    private let groupNameStackView = UIStackView()
    private let groupNameSkeletonView = SkeletonView()
    
    private let memberInfoLabel = UILabel()
    private let memberInfoSkeletonView = SkeletonView()
    private let joinCodeInfoLabel = UILabel()
    private let joinCodeCopyImageView = UIImageView(image: .copy)
    private let joinCodeInfoStackView = UIStackView()
    private let joinCodeInfoSkeletonView = SkeletonView()
    private let endDateInfoLabel = UILabel()
    private let endDateInfoSkeletonView = SkeletonView()
    
    private var memberStackView = UIStackView()
    private var joinCodeStackView = UIStackView()
    private var endDateStackView = UIStackView()
    
    private let groupInfoStackView = UIStackView()
    
    // TODO: 추후 Label 전체 개선 시 다른 descriptionLabel들과 통일하도록 수정
    private let durationDescriptionLabel = UILabel()
    private let durationInfoLabel = UILabel()
    private let durationInfoStackView = UIStackView()
    private let durationInfoSkeletonView = SkeletonView()
    private let durationProgressView = UIProgressView()
    
    private let durationStackView = UIStackView()
    
    private var currentAlpha: CGFloat?
    private var isFirst: Bool = true
    
    override func configureView() {
        // FIXME: 임시 처리, 추후 수정
        dosikImageView.isHidden = type == .stats
        
        nameLabel.textColor = .blue300
        nameLabel.font = Fonts.head1B
        
        groupNameStackView.axis = .horizontal
        groupNameStackView.spacing = 4
        groupNameStackView.alignment = .center
        
        memberStackView = infoStackView(description: "그룹원")
        joinCodeStackView = infoStackView(description: "초대코드")
        endDateStackView = infoStackView(description: "종료일")
        
        memberInfoLabel.textColor = .grey0
        joinCodeInfoLabel.textColor = .grey0
        endDateInfoLabel.textColor = .grey0
        
        joinCodeInfoStackView.axis = .horizontal
        joinCodeInfoStackView.spacing = 2
        joinCodeInfoStackView.alignment = .center
        
        groupInfoStackView.axis = .horizontal
        groupInfoStackView.spacing = 16
        
        durationDescriptionLabel.text = "진행 현황"
        durationDescriptionLabel.textColor = .grey300
        durationDescriptionLabel.font = Fonts.body2R
        
        durationInfoLabel.text = "(n일차)"
        durationInfoLabel.textColor = .grey300
        durationInfoLabel.font = Fonts.smallR
        
        durationInfoStackView.axis = .horizontal
        durationInfoStackView.spacing = 2
        durationInfoStackView.alignment = .center
        
        durationStackView.axis = .horizontal
        durationStackView.spacing = 8
        durationStackView.alignment = .center
        
        durationProgressView.layer.cornerRadius = 4
        durationProgressView.clipsToBounds = true
        durationProgressView.trackTintColor = .grey800
        durationProgressView.progressTintColor = .blue300
        
        if let durationProgressLayer = durationProgressView.subviews.last {
            durationProgressLayer.layer.cornerRadius = 4
            durationProgressLayer.clipsToBounds = true
        }
        
        durationProgressView.transform = CGAffineTransform(translationX: 0, y: 1)   // MARK: 디자인 디테일 반영
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        memberStackView.addArrangedSubview(memberInfoLabel)
        
        [nameLabel, changeGroupImageView, nameSpacerView].forEach { groupNameStackView.addArrangedSubview($0) }
        
        // FIXME: 임시 처리, 추후 수정
        if type == .main {
            [joinCodeInfoLabel, joinCodeCopyImageView].forEach { joinCodeInfoStackView.addArrangedSubview($0) }
        }
        joinCodeStackView.addArrangedSubview(type == .main ? joinCodeInfoStackView : joinCodeInfoLabel)
        endDateStackView.addArrangedSubview(endDateInfoLabel)
        
        [memberStackView, joinCodeStackView, endDateStackView].forEach { groupInfoStackView.addArrangedSubview($0) }
        
        // FIXME: stats 상태 미처리, 추후 수정
        [durationDescriptionLabel, durationInfoLabel].forEach { durationInfoStackView.addArrangedSubview($0) }
        [durationInfoStackView, durationProgressView].forEach { durationStackView.addArrangedSubview($0) }
        
        [dosikImageView, groupNameStackView, groupInfoStackView, durationStackView].forEach { addSubview($0) }
        
        groupNameStackView.addSubview(groupNameSkeletonView)
        memberInfoLabel.addSubview(memberInfoSkeletonView)
        joinCodeInfoStackView.addSubview(joinCodeInfoSkeletonView)
        endDateInfoLabel.addSubview(endDateInfoSkeletonView)
        durationInfoStackView.addSubview(durationInfoSkeletonView)
    }
    
    override func configureConstraints() {
        dosikImageView.snp.makeConstraints {
            $0.top.right.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        
        groupNameStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(type.groupNameTopOffset)
            $0.left.equalToSuperview()
            $0.right.equalTo(dosikImageView.snp.left).offset(-12)
            $0.height.equalTo(36)
        }
        
        changeGroupImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        groupInfoStackView.snp.makeConstraints {
            $0.top.equalTo(groupNameStackView.snp.bottom).offset(12)
            $0.left.equalToSuperview()
        }
        
        joinCodeCopyImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        durationProgressView.snp.makeConstraints {
            $0.height.equalTo(8)
        }
        
        durationStackView.snp.makeConstraints {
            $0.top.equalTo(groupInfoStackView.snp.bottom).offset(22)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(21)
        }
        
        [ groupNameSkeletonView,
          memberInfoSkeletonView, joinCodeInfoSkeletonView, endDateInfoSkeletonView,
          durationInfoSkeletonView
        ].forEach { $0.snp.makeConstraints { $0.edges.equalToSuperview() } }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let data = data as? GroupEntity {
            if isFirst {
                isFirst = false
                
                [ groupNameSkeletonView,
                  memberInfoSkeletonView, joinCodeInfoSkeletonView, endDateInfoSkeletonView,
                  durationInfoSkeletonView
                ].forEach { $0.removeFromSuperview() }
            }
            nameLabel.text = data.name
            
            memberInfoLabel.attributedText = NSAttributedString(
                string: "\(data.currentMember)/\(data.maximumMember)",
                attributes: Fonts.getAttributes(for: Fonts.body1S, textAlignment: .left)
            )
            joinCodeInfoLabel.attributedText = NSAttributedString(
                string: data.joinCode,
                attributes: Fonts.getAttributes(for: Fonts.body1S, textAlignment: .left)
            )
            endDateInfoLabel.attributedText = NSAttributedString(
                string: data.endDate,
                attributes: Fonts.getAttributes(for: Fonts.body1S, textAlignment: .left)
            )
            
            durationInfoLabel.text = "(\(data.duration)일차)"
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) { [weak self] in
                guard let self else { return }
                durationProgressView.setProgress(data.progress, animated: true)
            }
        }
        
        if let datas = data as? SheetViewDatas {
            if currentAlpha == datas.alpha { return }
            currentAlpha = datas.alpha
            
            [dosikImageView, groupInfoStackView, durationStackView].forEach { $0.alpha = datas.alpha }
        }
    }
}

// MARK: private func
extension GroupInfoView {
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
}
