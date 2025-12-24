//
//  MyPagePage.swift
//  dogether
//
//  Created by yujaehong on 11/8/25.
//

import UIKit

final class MyPagePage: BasePage {
    var delegate: MyPageDelegate? {
        didSet {
            statsButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.goStatsViewAction()
                },
                for: .touchUpInside
            )
            
            myTodosListButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.goMyTodoListAction()
                },
                for: .touchUpInside
            )
            
            groupManagementButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.goGroupManagementAction()
                },
                for: .touchUpInside
            )
            
            settingButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.goSettingViewAction()
                },
                for: .touchUpInside
            )
        }
    }
    
    private let navigationHeader = NavigationHeader(title: "마이페이지")
    private let profileView = ProfileView()
    private let statsImageView = UIImageView()
    private let statsLabel = UILabel()
    private let statsButton = DogetherButton("통계 보러가기")
    private let statsContainerView = UIView()
    private let myTodosListButton = MyPageButton(icon: .timer, title: "인증목록")
    private let groupManagementButton = MyPageButton(icon: .group, title: "그룹관리")
    private let settingButton = MyPageButton(icon: .setting, title: "설정")
    private let mypageButtonStackView = UIStackView()
    
    override func configureView() {
        statsImageView.image = .happyDosik
        statsImageView.contentMode = .scaleAspectFit
        
        statsLabel.text = "그룹별 진행 상황을 모아봤어요!"
        statsLabel.font = Fonts.body1S
        statsLabel.textColor = .grey0
        statsLabel.textAlignment = .center
        
        statsContainerView.backgroundColor = .clear
        statsContainerView.layer.cornerRadius = 12
        statsContainerView.layer.borderColor = UIColor.grey800.cgColor
        statsContainerView.layer.borderWidth = 1.5
        
        mypageButtonStackView.axis = .vertical
    }
    
    override func configureAction() {
        navigationHeader.delegate = coordinatorDelegate
    }
    
    override func configureHierarchy() {
        [statsImageView, statsLabel, statsButton].forEach { statsContainerView.addSubview($0) }
        [myTodosListButton, groupManagementButton, settingButton].forEach { mypageButtonStackView.addArrangedSubview($0) }
        
        [navigationHeader, profileView, statsContainerView, mypageButtonStackView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        profileView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        statsContainerView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(16)
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
            $0.top.equalTo(statsContainerView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? ProfileViewDatas {
            profileView.updateView(datas)
        }
        
        if let datas = data as? DogetherButtonViewDatas {
            statsButton.updateView(datas)
        }
    }
}
