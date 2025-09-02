//
//  OnboardingPage.swift
//  dogether
//
//  Created by 승용 on 7/31/25.
//

import AuthenticationServices

final class OnboardingPage: BasePage {
    var delegate: OnboardingDelegate?
    
    private let scrollView = UIScrollView()
    private let onboardingStackView = UIStackView()
    private let pageControl = UIPageControl()
    private let signInButton = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
    
    private let onboardingStep: Int = 3
    private let pageControlHeight: CGFloat = 26
    private let buttonBottomPadding: CGFloat = 16
    private let buttonHeight: CGFloat = 50
    
    override func configureView() {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.contentSize.width = frame.width * CGFloat(onboardingStep)
        
        onboardingStackView.axis = .horizontal
        onboardingStackView.distribution = .fillEqually
        
        for pageIndex in 0 ..< onboardingStep {
            guard let onboardingStep = OnboardingSteps(rawValue: pageIndex + 1) else { return }
            onboardingStackView.addArrangedSubview(onboardingStepStackView(step: onboardingStep))
        }
        
        pageControl.numberOfPages = onboardingStep
        
        signInButton.cornerRadius = 12
    }
    
    override func configureAction() {
        scrollView.delegate = self
        
        pageControl.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                let page = pageControl.currentPage
                let offset = CGPoint(x: CGFloat(page) * scrollView.frame.width, y: 0)
                scrollView.setContentOffset(offset, animated: true)
            }, for: .valueChanged
        )
        
        signInButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                delegate?.signInAction()
            }, for: .touchUpInside
        )
    }
    
    override func configureHierarchy() {
        [scrollView, pageControl, signInButton].forEach { self.addSubview($0) }
        
        [onboardingStackView].forEach { scrollView.addSubview($0) }
    }
    
    override func configureConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        onboardingStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-(pageControlHeight + buttonBottomPadding + buttonHeight) / 2)
            $0.width.equalToSuperview().multipliedBy(onboardingStep)
        }
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(onboardingStackView.snp.bottom)
        }
        
        signInButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(buttonBottomPadding)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(buttonHeight)
        }
    }
}

// MARK: - private func
extension OnboardingPage {
    private func onboardingStepStackView(step: OnboardingSteps) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.attributedText = NSAttributedString(
            string: step.title,
            attributes: Fonts.getAttributes(for: Fonts.head1B, textAlignment: .center)
        )
        titleLabel.textColor = .grey0
        titleLabel.numberOfLines = 0
        
        let subTitleLabel = UILabel()
        subTitleLabel.attributedText = NSAttributedString(
            string: step.subTitle,
            attributes: Fonts.getAttributes(for: Fonts.body1R, textAlignment: .center)
        )
        subTitleLabel.textColor = .grey200
        subTitleLabel.numberOfLines = 0
        
        let imageView = UIImageView(image: step.image)
        let aspectRatio = imageView.frame.height / imageView.frame.width
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel, imageView])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.setCustomSpacing(8, after: titleLabel)
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(imageView.snp.width).multipliedBy(aspectRatio)
        }
        
        return stackView
    }
}

// MARK: - scroll
extension OnboardingPage: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.frame.width == .zero { return }
        
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
