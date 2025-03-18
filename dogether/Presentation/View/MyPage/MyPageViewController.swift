//
//  MyPageViewController.swift
//  dogether
//
//  Created by 박지은 on 2/14/25.
//

import UIKit
import SnapKit

final class MyPageViewController: BaseViewController {
    
    private let dogetherHeader = NavigationHeader(title: "마이페이지")
    
    private let profileImageView = {
        let imageView = UIImageView()
        imageView.image = .profile2
        return imageView
    }()
    
    private let nameLabel = {
        let label = UILabel()
        label.text = "\(UserDefaultsManager.shared.userFullName ?? "닉네임")"
        label.font = Fonts.head1B
        label.textColor = .grey100
        return label
    }()
    
    private let myHistory = {
        let button = UIButton()
        button.backgroundColor = .grey700
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let checkMyTodosLabel = {
        let label = UILabel()
        label.text = "내가 해낸 모든 투두들을 확인해보세요 !"
        label.font = Fonts.body1S
        label.textColor = .grey0
        label.textAlignment = .center
        return label
    }()
    
    private let goToButton = {
        let button = UIButton()
        button.setTitle("보러가기", for: .normal)
        button.titleLabel?.font = Fonts.body1B
        button.setTitleColor(.grey700, for: .normal)
        button.backgroundColor = .grey0
        button.layer.cornerRadius = 12
        return button
    }()
    
    // TODO: 추후 isJoining 값을 가져와 비활성화 하는 부분 추가
    //    private let leaveGroupView = {
    //        let view = UIView()
    //        return view
    //    }()
    
    private let logoutView = {
        let view = UIView()
        return view
    }()
    
    private let withdrawView = {
        let view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGestureReconizers()
    }
    
    override func configureHierarchy() {
        [dogetherHeader, profileImageView, nameLabel, myHistory, logoutView, withdrawView].forEach {
            //        [dogetherHeader, profileImageView, nameLabel, leaveGroupView, logoutView, withdrawView].forEach {
            view.addSubview($0)
        }
        
        [checkMyTodosLabel, goToButton].forEach {
            myHistory.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        
        dogetherHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(28)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(dogetherHeader.snp.bottom).offset(56)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        myHistory.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(131)
        }
        
        checkMyTodosLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        goToButton.snp.makeConstraints {
            $0.top.equalTo(checkMyTodosLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        //        setUpView(leaveGroupView, iconName: .leaveGroup, text: "그룹탈퇴")
        setUpView(logoutView, iconName: .logout, text: "로그아웃")
        setUpView(withdrawView, iconName: .withdraw, text: "회원탈퇴")
        
        //        leaveGroupView.snp.makeConstraints {
        //            $0.top.equalTo(myHistory.snp.bottom).offset(8)
        //            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
        //            $0.horizontalEdges.equalToSuperview().inset(16)
        //            $0.height.equalTo(48)
        //        }
        
        logoutView.snp.makeConstraints {
            $0.top.equalTo(myHistory.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
        
        withdrawView.snp.makeConstraints {
            $0.top.equalTo(logoutView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
    }
    
    override func configureView() { }
    
    private func setUpView(_ view: UIView, iconName: UIImage, text: String) {
        view.isUserInteractionEnabled = true
        
        let icon = UIImageView()
        icon.image = iconName.withRenderingMode(.alwaysTemplate)
        icon.tintColor = .grey100
        
        let label = UILabel()
        label.text = text
        label.textColor = .grey100
        
        let goToIcon = UIImageView()
        goToIcon.image = .chevronRight.withRenderingMode(.alwaysTemplate)
        goToIcon.tintColor = .grey400
        
        [icon, label, goToIcon].forEach {
            view.addSubview($0)
        }
        
        icon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(24)
        }
        
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(icon.snp.trailing).offset(8)
        }
        
        goToIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.height.equalTo(20)
        }
    }
    
    private func setupGestureReconizers() {
        goToButton.addTarget(self, action: #selector(goToDashBoard), for: .touchUpInside)
        
        //        let leaveGroupTap = UITapGestureRecognizer(target: self, action: #selector(leaveGroupTapped))
        //        leaveGroupView.addGestureRecognizer(leaveGroupTap)
        
        let logoutTap = UITapGestureRecognizer(target: self, action: #selector(logoutTapped))
        logoutView.addGestureRecognizer(logoutTap)
        
        let withdrawTap = UITapGestureRecognizer(target: self, action: #selector(withdrawTapped))
        withdrawView.addGestureRecognizer(withdrawTap)
    }
    
    @objc private func goToDashBoard() {
        NavigationManager.shared.pushViewController(MyDashboardViewController())
    }
    
    //    @objc private func leaveGroupTapped() {
    //        AlertHelper.alert(on: self,
    //                          title: "현재 그룹을 탈퇴하시겠어요?",
    //                          message: "그룹을 탈퇴하면 그룹 내 모든 데이터가\n삭제되어 복구할 수 없어요.",
    //                          okTitle: "탈퇴하기") {
    //
    //            // TODO: 추후 viewModel로 이동
    //            Task { @MainActor in
    //                try await NetworkManager.shared.request(GroupsRouter.leaveGroup)
    //
    //                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    //                    NavigationManager.shared.setNavigationController(StartViewController())
    //                }
    //            }
    //        } cancelAction: { }
    //    }
    
    @objc private func logoutTapped() {
        
        let alertView = CustomAlertView(type: .logout) {
            UserDefaultsManager.shared.accessToken = nil
            UserDefaultsManager.shared.userFullName = nil
            
            // 온보딩 화면으로 이동
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                NavigationManager.shared.setNavigationController(OnboardingViewController())
            }
        } cancelAction: { }
        
        self.view.addSubview(alertView)
        // 오토레이아웃 설정 (SnapKit 사용)
        alertView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // TODO: - 탈퇴하기 로직 구현
    @objc private func withdrawTapped() {
        
        let alertView = CustomAlertView(type: .deleteAccount) {
            
            // TODO: 회원 탈퇴 부분 임시로 추가, 추후 수정
            Task { @MainActor in
                let viewModel = OnboardingViewModel()
                try await viewModel.withdraw()
                
                UserDefaultsManager.shared.accessToken = nil
                UserDefaultsManager.shared.userFullName = nil
                
                NavigationManager.shared.setNavigationController(OnboardingViewController())
            }
        } cancelAction: { }
        
        self.view.addSubview(alertView)
        
        alertView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

