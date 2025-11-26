//
//  DosikCommentButton.swift
//  dogether
//
//  Created by seungyooooong on 5/16/25.
//

import UIKit

final class DosikCommentButton: BaseButton {
    private let commentLabel = UILabel()
    private let closeImageView = UIImageView(image: .close)
    
    private let tailImageView = UIImageView(image: .tail)
    private let commentStackView = UIStackView()
    
    override func configureView() {
        isHidden = true
        backgroundColor = .grey50
        layer.cornerRadius = 8
        layer.zPosition = 1
        
        commentLabel.textColor = .grey800
        commentLabel.numberOfLines = 0
        commentLabel.setContentHuggingPriority(.required, for: .vertical)
        commentLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        closeImageView.contentMode = .scaleAspectFit
        
        commentStackView.axis = .horizontal
        commentStackView.spacing = 4
        commentStackView.isUserInteractionEnabled = false
        
        [commentLabel, closeImageView].forEach { commentStackView.addArrangedSubview($0) }
    }
    
    override func configureAction() {
        addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                isHidden = true
            }, for: .touchUpInside
        )
    }
    
    override func configureHierarchy() {
        [tailImageView, commentStackView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        tailImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(7)
            $0.right.equalToSuperview().offset(-16)
            $0.width.height.equalTo(14)
        }

        closeImageView.snp.makeConstraints {
            $0.width.equalTo(12)
        }

        commentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let data = data as? GroupEntity {
            let comment = data.status == .dDay ? "그룹이 종료됐어요!" :
                data.progress >= 1.0 ? "마지막 인증일이에요!\n내일부터 인증이 불가능해요." : nil
            
            isHidden = comment == nil
            
            guard let comment else { return }
            
            commentLabel.attributedText = NSAttributedString(
                string: comment,
                attributes: Fonts.getAttributes(for: Fonts.smallS, textAlignment: .left)
            )
        }
    }
}
