//
//  ReviewFeedbackView.swift
//  dogether
//
//  Created by seungyooooong on 5/23/25.
//

import UIKit

final class ReviewFeedbackView: BaseView {
    private let reviewFeedbackLabel = UILabel()
    
    override func configureView() {
        backgroundColor = .grey700
        layer.cornerRadius = 8
        
        reviewFeedbackLabel.textColor = .grey0
        reviewFeedbackLabel.numberOfLines = 0
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
    
    // MARK: - updateView
    override func updateView(_ data: String) {
        isHidden = data.isEmpty
        reviewFeedbackLabel.attributedText = NSAttributedString(
            string: data,
            attributes: Fonts.getAttributes(for: Fonts.body1S, textAlignment: .left)
        )
    }
}
