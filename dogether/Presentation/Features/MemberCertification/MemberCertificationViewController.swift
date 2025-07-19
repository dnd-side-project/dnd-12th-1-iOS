//
//  MemberCertificationViewController.swift
//  dogether
//
//  Created by seungyooooong on 4/10/25.
//

import UIKit
import SnapKit

final class MemberCertificationViewController: BaseViewController {
    let viewModel = MemberCertificationViewModel()
    
    private let navigationHeader = NavigationHeader(title: "그룹원 인증 정보")
    
    private let thumbnailScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let thumbnailStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let certificationScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    private let certificationStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 32
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let statusContentView = UIView()
    
    private let statusContentStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    private var statusView = TodoStatusButton(type: .waitCertification)
    
    private var errorView: ErrorView?
    
    private let contentLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let reviewFeedbackLabel = ReviewFeedbackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMemberCertificationView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // FIXME: setUI가 끝나는 지점에서 updateView()를 호출해 스크롤 위치를 조정해주려고 시도했으나, scrollViewWidth가 0.0으로 잡히면서 나눗셈이 불가능, 추후 수정
        updateView()
    }
    
    override func configureView() {
        guard let memberInfo = viewModel.memberInfo else { return }
        navigationHeader.setTitle(title: "\(memberInfo.name)님의 인증 정보")
    }
    
    override func configureAction() {
        navigationHeader.delegate = self
        
        thumbnailScrollView.delegate = self
        let thumbnailScrollViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedThumbnailScrollView(_:)))
        thumbnailScrollView.addGestureRecognizer(thumbnailScrollViewTapGesture)
        
        certificationScrollView.delegate = self
        let certificationScrollViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedCertificationScrollView(_:)))
        certificationScrollView.addGestureRecognizer(certificationScrollViewTapGesture)
    }
    
    override func configureHierarchy() {
        [navigationHeader, thumbnailScrollView, certificationScrollView, statusContentView].forEach { view.addSubview($0) }
        [thumbnailStackView].forEach { thumbnailScrollView.addSubview($0) }
        [certificationStackView].forEach { certificationScrollView.addSubview($0) }
        [statusContentStackView].forEach { statusContentView.addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        thumbnailScrollView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom).offset(2)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(54)
        }
        
        thumbnailStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        certificationScrollView.snp.makeConstraints {
            $0.top.equalTo(thumbnailScrollView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(view.frame.width - 32)
        }
        
        statusContentView.snp.makeConstraints {
            $0.top.equalTo(certificationScrollView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        statusContentStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
    }
}

// MARK: - scroll
extension MemberCertificationViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === certificationScrollView {
            let index = Int(round(scrollView.contentOffset.x / view.frame.width))
            if index == viewModel.currentIndex { return }
            viewModel.setCurrentIndex(index: index)
            updateView()
        }
    }
}

extension MemberCertificationViewController {
    private func loadMemberCertificationView() {
        Task {
            do {
                try await viewModel.loadMemberCertificationView()
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    showMainContentViews()
                    setUI()
                }
            } catch let error as NetworkError {
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    hideMainContentViews()
                    showErrorView(error: error)
                }
            }
        }
    }
    
    private func setUI() {
        viewModel.todos
            .enumerated().map {
                ThumbnailView(
                    imageUrl: $1.certificationMediaUrl,
                    thumbnailStatus: $1.thumbnailStatus,
                    isHighlighted: $0 == viewModel.currentIndex
                )
            }
            .forEach {
                thumbnailStackView.addArrangedSubview($0)
            }
        
        viewModel.todos
            .map {
                if let mediaUrl = $0.certificationMediaUrl {
                    CertificationImageView(imageUrl: mediaUrl, certificationContent: $0.certificationContent)
                } else {
                    CertificationImageView(
                        image: .embarrassedDosik.imageWithPadding(
                            insets: UIEdgeInsets(top: 41 * 4, left: 62 * 4, bottom: 83 * 4, right: 62 * 4), backgroundColor: .grey800
                        ),
                        certificationContent: "아직 열심히 진행중이에요"
                    )
                }
            }
            .forEach {
                certificationStackView.addArrangedSubview($0)
            }
        
        certificationStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.width.equalTo(view.frame.width * CGFloat(viewModel.todos.count) - 32)
            $0.height.equalToSuperview()
        }
    }
    
    private func updateView() {
        guard !viewModel.todos.isEmpty, viewModel.currentIndex < viewModel.todos.count else { return }
        
        if viewModel.todos[viewModel.currentIndex].thumbnailStatus == .yet {
            viewModel.readTodo()
        }
        
        thumbnailStackView.arrangedSubviews.enumerated().forEach { index, view in
            guard let view = view as? ThumbnailView else { return }
            // TODO: beforeIndex, currentIndex만 처리할지 고민해보기
            view.setStatus(status: viewModel.todos[index].thumbnailStatus)
            view.setIsHighlighted(isHighlighted: index == viewModel.currentIndex)
            
            if index == viewModel.currentIndex {
                let scrollViewWidth = thumbnailScrollView.bounds.width
                let idealOffset = view.frame.midX - scrollViewWidth / 2 + 16
                let newOffset = max(0, min(idealOffset, thumbnailScrollView.contentSize.width - scrollViewWidth))
                thumbnailScrollView.setContentOffset(CGPoint(x: newOffset, y: 0), animated: true)
            }
        }
        
        certificationStackView.arrangedSubviews.enumerated().forEach { index, view in
            let scrollViewWidth = certificationScrollView.bounds.width
            let index = Int(round(certificationScrollView.contentOffset.x / scrollViewWidth))
            
            if index == viewModel.currentIndex { return }
            
            let newOffset = CGPoint(x: scrollViewWidth * CGFloat(viewModel.currentIndex), y: 0)
            certificationScrollView.setContentOffset(newOffset, animated: false)
        }
        
        statusView.update(type: viewModel.todos[viewModel.currentIndex].status)
        
        contentLabel.attributedText = NSAttributedString(
            string: viewModel.todos[viewModel.currentIndex].content,
            attributes: Fonts.getAttributes(for: Fonts.head1B, textAlignment: .center)
        )
        
        statusContentStackView.subviews.forEach { statusContentStackView.removeArrangedSubview($0) }
        [statusView, contentLabel].forEach { statusContentStackView.addArrangedSubview($0) }
        
        reviewFeedbackLabel.isHidden = true
        guard let feedback = viewModel.todos[viewModel.currentIndex].feedback, feedback.count > 0 else { return }
        reviewFeedbackLabel.isHidden = false
        reviewFeedbackLabel.updateFeedback(feedback: feedback)
        statusContentStackView.addArrangedSubview(reviewFeedbackLabel)
        reviewFeedbackLabel.snp.makeConstraints { $0.horizontalEdges.equalToSuperview() }
    }
    
    @objc private func tappedThumbnailScrollView(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: thumbnailStackView)

        for (index, view) in thumbnailStackView.arrangedSubviews.enumerated() {
            if view.frame.contains(location) {
                viewModel.setCurrentIndex(index: index)
                updateView()
                return
            }
        }
    }
    
    @objc private func tappedCertificationScrollView(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: certificationScrollView)
        let scrollViewWidth = certificationScrollView.bounds.width
        
        // MARK: view 중앙을 기준으로 direction 결정
        let direction: Directions = location.x - certificationScrollView.contentOffset.x < scrollViewWidth / 2 ? .prev : .next
        let index = Int(round(certificationScrollView.contentOffset.x / scrollViewWidth))
        let nextIndex = index + direction.tag
        
        if nextIndex < 0 || certificationStackView.arrangedSubviews.count <= nextIndex { return }
        
        let newOffset = CGPoint(x: scrollViewWidth * CGFloat(nextIndex), y: 0)
        certificationScrollView.setContentOffset(newOffset, animated: true)
    }
}

// MARK: - ErrorView
extension MemberCertificationViewController {
    private func showErrorView(error: NetworkError) {
        errorView?.removeFromSuperview()
        errorView = ErrorHandlingManager.embedErrorView(
            in: self,
            under: navigationHeader,
            error: error,
            retryHandler: { [weak self] in
                guard let self else { return }
                loadMemberCertificationView()
            }
        )
    }
    
    private func hideMainContentViews() {
        [thumbnailScrollView, certificationScrollView, statusContentView].forEach { $0.isHidden = true }
    }

    private func showMainContentViews() {
        [thumbnailScrollView, certificationScrollView, statusContentView].forEach { $0.isHidden = false }
        errorView = nil
    }
}
