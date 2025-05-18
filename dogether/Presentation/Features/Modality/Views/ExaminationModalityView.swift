//
//  ExaminationModalityView.swift
//  dogether
//
//  Created by seungyooooong on 2/17/25.
//

import UIKit
import SnapKit

final class ExaminationModalityView: BasePopupView {
    init() {
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
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
            $0.width.height.equalTo(type == .reject ? 22 : 24)    // MARK: 임의로 사이즈 조정
        }
        
        return button
    }
    var rejectButton = UIButton()
    var approveButton = UIButton()
    
    private func examinationStackView(buttons: [UIButton]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.spacing = 11
        stackView.distribution = .fillEqually
        return stackView
    }
    private var examinationStackView = UIStackView()
    
    override func configureView() {
        backgroundColor = .grey800
        layer.cornerRadius = 12
        
        rejectButton = examinationButton(type: .reject)
        approveButton = examinationButton(type: .approve)
        examinationStackView = examinationStackView(buttons: [rejectButton, approveButton])
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [imageView, contentLabel, examinationStackView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.width.height.equalTo(imageView.snp.width)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
        
        examinationStackView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(16)
            $0.bottom.equalToSuperview().inset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }
    }
}
 
extension ExaminationModalityView {
    func setReview(review: ReviewModel) {
        imageView.image = .logo
        imageView.updateCertificator(certificator: review.doer)
        imageView.updateCertificationContent(certificationContent: review.content)
        
        Task { [weak self] in
            guard let self else { return }
            try await imageView.loadImage(url: review.mediaUrl)
        }
        
        contentLabel.attributedText = NSAttributedString(
            string: review.todoContent,
            attributes: Fonts.getAttributes(for: Fonts.head2B, textAlignment: .center)
        )
    }
    
    func updateButtonBackgroundColor(type: FilterTypes) {
        rejectButton.backgroundColor = type == .reject ? .dogetherRed : .grey0
        approveButton.backgroundColor = type == .approve ? .blue300 : .grey0
    }
}
