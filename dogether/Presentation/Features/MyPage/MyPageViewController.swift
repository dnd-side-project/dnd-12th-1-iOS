//
//  MyPageViewController.swift
//  dogether
//
//  Created by seungyooooong on 3/31/25.
//

import UIKit
import SnapKit

final class MyPageViewController: BaseViewController {
    private let viewModel = MyPageViewModel()
    private let navigationHeader = NavigationHeader(title: "마이페이지")
    
    private var profileImageView = UIImageView(image: .profile)
    
    private let nameLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.font = Fonts.head2B
        return label
    }()
    
    private let userProfileStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }()
    
    private let statsImageView: UIImageView = {
        let imageView = UIImageView(image: .happyDusik)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let statsLabel: UILabel = {
        let label = UILabel()
        label.text = "그룹별 진행 상황을 모아봤어요!"
        label.font = Fonts.body1S
        label.textColor = .grey0
        label.textAlignment = .center
        return label
    }()
    
    private let statsButton: UIButton = {
        let button = UIButton()
        button.setTitle("통계 보러가기", for: .normal)
        button.setTitleColor(.grey900, for: .normal)
        button.titleLabel?.font = Fonts.body1B
        button.backgroundColor = .blue300
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let statsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor.grey800.cgColor
        view.layer.borderWidth = 1.5
        return view
    }()
    
    private let myTodosListButton = MyPageButton(icon: .timer, title: "인증목록")
    private let groupManagementButton = MyPageButton(icon: .group, title: "그룹관리")
    private let settingButton = MyPageButton(icon: .setting, title: "설정")
    
    private let mypageButtonStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task { [weak self] in
            guard let self else { return }
            
            try await viewModel.getMyProfile()
            nameLabel.text = viewModel.myProfile?.name
            profileImageView.loadImage(url: viewModel.myProfile?.profileImageUrl)
        }
    }
    
    override func configureView() {
        [profileImageView, nameLabel].forEach { userProfileStackView.addArrangedSubview($0) }
        [statsImageView, statsLabel, statsButton].forEach { statsContainerView.addSubview($0) }
        [myTodosListButton, groupManagementButton, settingButton].forEach { mypageButtonStackView.addArrangedSubview($0) }
    }
    
    override func configureAction() {
        navigationHeader.delegate = self
        
        statsButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                coordinator?.pushViewController(StatsViewController())
            }, for: .touchUpInside
        )
        
        myTodosListButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                coordinator?.pushViewController(CertificationListViewController())
            }, for: .touchUpInside
        )
        
        groupManagementButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                coordinator?.pushViewController(GroupManagementViewController())
            }, for: .touchUpInside
        )
        
        settingButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                coordinator?.pushViewController(SettingViewController())
            }, for: .touchUpInside
        )
    }
    
    override func configureHierarchy() {
        [navigationHeader, statsContainerView, userProfileStackView, mypageButtonStackView].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(48)
        }
        
        userProfileStackView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom).offset(14)
            $0.horizontalEdges.equalToSuperview().inset(16)
            
        }
        
        statsContainerView.snp.makeConstraints {
            $0.top.equalTo(userProfileStackView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(251)
        }
        
        statsImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(33)
            $0.width.equalTo(86)
            $0.height.equalTo(94)
        }
        
        statsLabel.snp.makeConstraints {
            $0.top.equalTo(statsImageView.snp.bottom).offset(13)
            $0.centerX.equalToSuperview()
        }
        
        statsButton.snp.makeConstraints {
            $0.top.equalTo(statsLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        mypageButtonStackView.snp.makeConstraints {
            $0.top.equalTo(statsContainerView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
