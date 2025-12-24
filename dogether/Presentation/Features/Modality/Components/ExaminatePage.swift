//
//  ExaminatePage.swift
//  dogether
//
//  Created by seungyooooong on 12/4/25.
//

import UIKit

final class ExaminatePage: BasePage {
    var delegate: ExaminateDelegate? {
        didSet {
            [rejectButton, approveButton].forEach { button in
                button.addAction(
                    UIAction { [weak self, weak button] _ in
                        guard let self, let button,
                              let type = FilterTypes.allCases.first(where: { $0.tag == button.tag }) else { return }
                        delegate?.examinateAction(type: type)
                    }, for: .touchUpInside
                )
            }
            
            sendButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.sendAction()
                }, for: .touchUpInside
            )
        }
    }
    
    private let scrollView = UIScrollView()
    private let sendButton = DogetherButton("보내기")
    private let contentStackView = UIStackView()
    private let titleLabel = UILabel()
    private let descriptionView = ExaminateDescriptionView()
    private let imageView = CertificationImageView(type: .logo)
    private let contentLabel = UILabel()
    private let rejectButton = ExaminateButton(type: .reject)
    private let approveButton = ExaminateButton(type: .approve)
    private let examinationStackView = UIStackView()
    private let reviewFeedbackView = ReviewFeedbackView()
    
    private(set) var currentReview: ReviewEntity?
    private(set) var currentFeedback: String?
    private(set) var currentResult: ReviewResults?
    
    override func configureView() {
        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        
        titleLabel.text = "투두를 검사해주세요!"
        titleLabel.textColor = .grey0
        titleLabel.font = Fonts.head1B
        titleLabel.textAlignment = .center
        
        contentLabel.textColor = .grey0
        contentLabel.numberOfLines = 0
        
        examinationStackView.axis = .horizontal
        examinationStackView.spacing = 8
        examinationStackView.distribution = .fillEqually
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [rejectButton, approveButton].forEach { examinationStackView.addArrangedSubview($0) }
        
        [ titleLabel, descriptionView,
          imageView, contentLabel, examinationStackView
        ].forEach { contentStackView.addArrangedSubview($0) }
        contentStackView.setCustomSpacing(4, after: titleLabel)
        contentStackView.setCustomSpacing(24, after: descriptionView)
        contentStackView.setCustomSpacing(16, after: imageView)
        contentStackView.setCustomSpacing(16, after: contentLabel)
        
        [scrollView, sendButton].forEach { addSubview($0) }
        [contentStackView].forEach { scrollView.addSubview($0) }
    }
    
    override func configureConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(50 + 16 + 16)
            $0.horizontalEdges.equalToSuperview()
        }
        
        sendButton.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview().inset(16)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(36)
        }
        
        descriptionView.snp.makeConstraints {
            $0.height.equalTo(25)
        }
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(scrollView.snp.width).offset(-32)
        }
        
        examinationStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? ExaminateViewDatas {
            if currentReview != datas.reviews[datas.index] {
                currentReview = datas.reviews[datas.index]
                
                let certificationImageViewDatas = CertificationImageViewDatas(
                    image: .logo,
                    imageUrl: datas.reviews[datas.index].mediaUrl,
                    content: datas.reviews[datas.index].content,
                    certificator: datas.reviews[datas.index].doer
                )
                imageView.updateView(certificationImageViewDatas)
                
                contentLabel.attributedText = NSAttributedString(
                    string: datas.reviews[datas.index].todoContent,
                    attributes: Fonts.getAttributes(for: Fonts.head2B, textAlignment: .center)
                )
            }
            
            if currentFeedback != datas.feedback {
                currentFeedback = datas.feedback
                
                reviewFeedbackView.updateView(datas.feedback)
                if datas.feedback.isEmpty {
                    contentStackView.removeArrangedSubview(reviewFeedbackView)
                    
                    reviewFeedbackView.snp.removeConstraints()
                } else {
                    contentStackView.addArrangedSubview(reviewFeedbackView)
                    contentStackView.setCustomSpacing(16, after: examinationStackView)
                    
                    reviewFeedbackView.snp.makeConstraints {
                        $0.horizontalEdges.equalToSuperview()
                    }
                }
            }
            
            if currentResult != datas.result {
                currentResult = datas.result
                
                rejectButton.updateView(datas.result == .reject ? .dogetherRed : .grey0)
                approveButton.updateView(datas.result == .approve ? .blue300 : .grey0)
            }
        }
            
            
        if let datas = data as? DogetherButtonViewDatas {
            sendButton.updateView(datas)
        }
    }
}
