//
//  ExaminationModalityView.swift
//  dogether
//
//  Created by seungyooooong on 2/17/25.
//

import UIKit
import SnapKit

final class ExaminationModalityView: BaseView {
    init() { super.init(frame: .zero) }
    required init?(coder: NSCoder) { fatalError() }
    
    private let scrollView = UIScrollView()
    
    var closeButton = DogetherButton("보내기")
    
    private let contentStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        return stackView
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "투두를 검사해주세요!"
        label.textColor = .grey0
        label.font = Fonts.head1B
        label.textAlignment = .center
        return label
    }()
    
    private var imageView = CertificationImageView(image: .logo)
    
    private let contentLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.numberOfLines = 0
        return label
    }()
    
    private func examinationButton(type: FilterTypes) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .grey0
        button.layer.cornerRadius = 8
        button.tag = type.tag
        
        let icon = UIImageView(image: type.image?.withRenderingMode(.alwaysTemplate))
        icon.tintColor = .grey700
        
        let label = UILabel()
        label.text = type.rawValue
        label.textColor = .grey700
        label.font = Fonts.body1S
        
        let stackView = UIStackView(arrangedSubviews: [icon, label])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.isUserInteractionEnabled = false
        
        [stackView].forEach { button.addSubview($0) }
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        icon.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        return button
    }
    var rejectButton = UIButton()
    var approveButton = UIButton()
    
    private var examinationStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 11
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let reviewFeedbackView = ReviewFeedbackView()
    
    override func configureView() {
        rejectButton = examinationButton(type: .reject)
        approveButton = examinationButton(type: .approve)
        
        [rejectButton, approveButton].forEach { examinationStackView.addArrangedSubview($0) }
        
        [titleLabel, imageView, contentLabel, examinationStackView].forEach { contentStackView.addArrangedSubview($0) }
        contentStackView.setCustomSpacing(60, after: titleLabel)
        contentStackView.setCustomSpacing(16, after: imageView)
        contentStackView.setCustomSpacing(16, after: contentLabel)
        
        // FIXME: 추후 수정
        let dogetherButtonViewDatas = closeButton.currentViewDatas ?? DogetherButtonViewDatas(status: .disabled)
        closeButton.updateView(dogetherButtonViewDatas)
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [scrollView, closeButton].forEach { addSubview($0) }
        [contentStackView].forEach { scrollView.addSubview($0) }
    }
    
    override func configureConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(50 + 16 + 16)
            $0.horizontalEdges.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview().inset(16)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(44)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(36)
        }
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(scrollView.snp.width).offset(-32)
        }
        
        examinationStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48)
        }
    }
}
 
extension ExaminationModalityView {
    func setReview(review: ReviewModel) {
        imageView.image = .logo
        imageView.loadImage(url: review.mediaUrl)
        imageView.updateCertificator(certificator: review.doer)
        imageView.updateCertificationContent(certificationContent: review.content)
        
        contentLabel.attributedText = NSAttributedString(
            string: review.todoContent,
            attributes: Fonts.getAttributes(for: Fonts.head2B, textAlignment: .center)
        )
    }
    
    func updateButtonBackgroundColor(type: FilterTypes) {
        rejectButton.backgroundColor = type == .reject ? .dogetherRed : .grey0
        approveButton.backgroundColor = type == .approve ? .blue300 : .grey0
    }
    
    func addFeedback(feedback: String) {
        reviewFeedbackView.updateFeedback(feedback: feedback)
        reviewFeedbackView.isHidden = false
        
        contentStackView.addArrangedSubview(reviewFeedbackView)
        contentStackView.setCustomSpacing(16, after: examinationStackView)
        
        reviewFeedbackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    func removeFeedback() {
        reviewFeedbackView.isHidden = true
        
        contentStackView.removeArrangedSubview(reviewFeedbackView)
            
        reviewFeedbackView.snp.removeConstraints()
    }
}
