//
//  LoginViewController.swift
//  dogether
//
//  Created by 박지은 on 2/5/25.
//

import UIKit
import AuthenticationServices
import SnapKit

final class OnboardingViewController: BaseViewController {
    
    private let viewModel = OnboardingViewModel()
    
    private lazy var scrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    private let pageControl = {
        let control = UIPageControl()
        return control
    }()
    
    private let contentView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()
    
    private lazy var nextButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.grey800, for: .normal)
        button.titleLabel?.font = Fonts.body1B
        button.backgroundColor = .blue300
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var signInButton =  {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
        button.cornerRadius = 12
        button.addTarget(self, action: #selector(signInButtonClicked), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureHierarchy() {
        [scrollView, pageControl, nextButton, signInButton].forEach { view.addSubview($0) }
        scrollView.addSubview(contentView)
    }
    
    override func configureConstraints() {
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(470)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
            $0.width.equalTo(view.frame.width * CGFloat(pageControl.numberOfPages)) // 페이지 개수만큼 너비 설정
        }
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(scrollView.snp.bottom).offset(24)
        }
        
        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(pageControl.snp.bottom).offset(64)
            $0.height.equalTo(50)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        signInButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(pageControl.snp.bottom).offset(64)
            $0.height.equalTo(50)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        
        for i in 1...3 {
            let pageView = createPageView(index: i)
            contentView.addArrangedSubview(pageView)
        }
    }
    
    @objc private func nextButtonClicked() {
        let nextPage = pageControl.currentPage + 1
        if nextPage < pageControl.numberOfPages {
            let nextOffset = CGPoint(x: CGFloat(nextPage) * view.frame.width, y: 0)
            scrollView.setContentOffset(nextOffset, animated: true)
        }
    }
    
    @objc private func signInButtonClicked() {
        Task { @MainActor in
            let response = try await viewModel.signInWithApple()
            print("✅ 로그인 성공: \(response.name), 토큰: \(response.accessToken)")
            
            UserDefaultsManager.shared.userFullName = response.name
            UserDefaultsManager.shared.accessToken = response.accessToken
            
            viewModel.saveNotiToken()
            
            let IsJoiningResponse: GetIsJoiningResponse = try await NetworkManager.shared.request(GroupsRouter.getIsJoining)
            
            if IsJoiningResponse.isJoining {
                NavigationManager.shared.setNavigationController(MainViewController())
            } else {
                NavigationManager.shared.setNavigationController(StartViewController())
            }
        }
    }
    
    private func createPageView(index: Int) -> UIView {
        
        let title = {
            let label = UILabel()
            label.textAlignment = .center
            label.font = Fonts.head1B
            label.textColor = .grey0
            label.numberOfLines = 0
            return label
        }()
        
        let subtitle = {
            let label = UILabel()
            label.font = Fonts.body1R
            label.textColor = .grey200
            label.numberOfLines = 0
            label.textAlignment = .center
            return label
        }()
        
        let view = {
            let view = UIView()
            return view
        }()
        
        let imageView = {
            let view = UIImageView()
            return view
        }()
        
        switch index {
        case 1:
            title.text = "오늘의 목표를 세우고,\n사진으로 투두 인증하기"
            subtitle.text = "목표만 세우면 끝?! 인증까지 해야 진짜 실천이에요"
            imageView.image = .onboarding1
            
        case 2:
            title.text = "투두를 인증하면\n날아오는 팀원의 피드백"
            subtitle.text = "열심히 하면 ‘인정’, 대충하면 ‘노인정’을 받아요"
            imageView.image = .onboarding2
            
        case 3:
            title.text = "서로 검사해야 다음 목표로 GO"
            subtitle.text = " 팀원의 인증을 검사해야\n새로운 목표를 설정할 수 있어요"
            imageView.image = .onboarding3
            
        default:
            break
        }
        
        [title, subtitle, imageView].forEach {
            view.addSubview($0)
        }
        
        title.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        subtitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(title.snp.bottom).offset(8)
        }
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(subtitle.snp.bottom).offset(36)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(340)
        }
        return view
    }
}

// MARK: - 로그인 인증 화면 요청
extension OnboardingViewController: ASWebAuthenticationPresentationContextProviding {
    
    // 인증창을 보여주기 위한 메서드(인증창을 보여줄 화면을 설정)
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        self.view.window ?? UIWindow()
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        let isLastPage = pageControl.currentPage == pageControl.numberOfPages - 1
        
        signInButton.isHidden = !isLastPage
        nextButton.isHidden = isLastPage
    }
}
