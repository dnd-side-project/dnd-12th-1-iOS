//
//  DosikCommentButton.swift
//  dogether
//
//  Created by seungyooooong on 5/16/25.
//

import UIKit

final class DosikCommentButton: BaseButton {
    init() { super.init(frame: .zero) }
    required init?(coder: NSCoder) { fatalError() }
    
    private let tailImageView = UIImageView(image: .tail)
    
    private let commentLabel = {
        let label = UILabel()
        label.textColor = .grey800
        label.numberOfLines = 0
        return label
    }()

    private let closeImageView = {
        let imageView = UIImageView(image: .close)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let commentStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.isUserInteractionEnabled = false
        return stackView
    }()
    
    override func configureView() {
        isHidden = true
        backgroundColor = .grey50
        layer.cornerRadius = 8
        layer.zPosition = 1
        
        commentLabel.setContentHuggingPriority(.required, for: .vertical)
        commentLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
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
}

extension DosikCommentButton {
    func updateUI(comment: String? = nil) {
        isHidden = comment == nil
        
        guard let comment else { return }
        
        commentLabel.attributedText = NSAttributedString(
            string: comment,
            attributes: Fonts.getAttributes(for: Fonts.smallS, textAlignment: .left)
        )
    }
}
