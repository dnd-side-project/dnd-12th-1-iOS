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
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? CertificationViewDatas {
            isHidden = !(datas.todos[datas.index].reviewFeedback?.isEmpty == false)
            updateFeedback(feedback: datas.todos[datas.index].reviewFeedback ?? "")
        }
    }
}

// FIXME: 추후 삭제
extension ReviewFeedbackView {
    func updateFeedback(feedback: String) {
        reviewFeedbackLabel.attributedText = NSAttributedString(
            string: feedback,
            attributes: Fonts.getAttributes(for: Fonts.body1S, textAlignment: .left)
        )
    }
}
