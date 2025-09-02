//
//  UpdatePage.swift
//  dogether
//
//  Created by 승용 on 7/31/25.
//

import UIKit

final class UpdatePage: BasePage {
    var delegate: UpdateDelegate?
    
    private let typoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let updateImageView = UIImageView()
    private let updateStackView = UIStackView()
    private let updateContainerView = UIView()
    
    private let updateButton = DogetherButton(title: "업데이트 하러가기")
    
    override func configureView() {
        typoImageView.image = .logoTypo
        typoImageView.contentMode = .scaleAspectFit
        
        titleLabel.text = "두게더가 새로워졌어요!"
        titleLabel.textColor = .grey0
        titleLabel.font = Fonts.head1B
        
        descriptionLabel.attributedText = NSAttributedString(
            string: "두게더가 유저분들의 의견을 반영하여\n더 편하게 사용하도록 사용성을 개선했어요.\n지금 바로 업데이트하고 인증하러 가요!",
            attributes: Fonts.getAttributes(for: Fonts.body1R, textAlignment: .center)
        )
        descriptionLabel.textColor = .grey200
        descriptionLabel.numberOfLines = 0
        
        updateImageView.image = .partyDosik
        updateImageView.contentMode = .scaleAspectFit
        
        [typoImageView, titleLabel, descriptionLabel, updateImageView].forEach { updateStackView.addArrangedSubview($0) }
        updateStackView.axis = .vertical
        updateStackView.alignment = .center
        updateStackView.distribution = .fill
        
        updateStackView.setCustomSpacing(40, after: typoImageView)
        updateStackView.setCustomSpacing(8, after: titleLabel)
        updateStackView.setCustomSpacing(44, after: descriptionLabel)
    }
    
    override func configureAction() {
        updateButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                delegate?.updateAction()
            }, for: .touchUpInside
        )
    }
    
    override func configureHierarchy() {
        [updateContainerView, updateButton].forEach { addSubview($0) }
        [updateStackView].forEach { updateContainerView.addSubview($0) }
    }
    
    override func configureConstraints() {
        typoImageView.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(36)
        }
        
        updateImageView.snp.makeConstraints {
            guard let image = updateImageView.image else { return }
            let aspectRatio = image.size.height / image.size.width
            
            $0.width.equalToSuperview()
            $0.height.equalTo(updateImageView.snp.width).multipliedBy(aspectRatio)
        }
        
        updateStackView.snp.makeConstraints {
            $0.center.width.equalToSuperview()
        }
        
        updateContainerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalTo(updateButton.snp.top)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        updateButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
