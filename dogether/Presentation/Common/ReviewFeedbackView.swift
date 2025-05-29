//
//  ReviewFeedbackView.swift
//  dogether
//
//  Created by seungyooooong on 5/23/25.
//

import UIKit

final class ReviewFeedbackView: BaseView {
    init() { super.init(frame: .zero) }
    required init?(coder: NSCoder) { fatalError() }
    
    private let reviewFeedbackLabel = {
        let label = UILabel()
        label.textColor = .grey100
        label.numberOfLines = 0
        return label
    }()
    
    override func configureView() {
        backgroundColor = .grey600
        layer.cornerRadius = 8
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        addSubview(reviewFeedbackLabel)
    }
    
    override func configureConstraints() {
        reviewFeedbackLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview().inset(10)
        }
    }
}

extension ReviewFeedbackView {
    func updateFeedback(feedback: String) {
        reviewFeedbackLabel.attributedText = NSAttributedString(
            string: feedback,
            attributes: Fonts.getAttributes(for: Fonts.body1S, textAlignment: .left)
        )
    }
}
