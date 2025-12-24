//
//  JoinCodeShareButton.swift
//  dogether
//
//  Created by yujaehong on 10/28/25.
//

import UIKit

final class JoinCodeShareButton: BaseButton {
    private let codeLabel = UILabel()
    private let iconImageView = UIImageView(
        image: .share.withRenderingMode(.alwaysTemplate)
    )
    private let stackView = UIStackView()
    
    override func configureView() {
        layer.cornerRadius = 12
        backgroundColor = .grey700
        
        codeLabel.textColor = .grey0
        codeLabel.font = Fonts.head1B
        
        iconImageView.tintColor = .grey400
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.isUserInteractionEnabled = false
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        addSubview(stackView)
        stackView.addArrangedSubview(codeLabel)
        stackView.addArrangedSubview(iconImageView)
    }
    
    
    override func configureConstraints() {
        self.snp.makeConstraints {
            $0.height.equalTo(75)
        }
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        codeLabel.snp.makeConstraints {
            $0.height.equalTo(36)
        }
        
        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
    }
    
    override func updateView(_ data: any BaseEntity) {
        guard let data = data as? JoinCodeShareButtonViewData else { return }
        codeLabel.text = data.joinCode
    }
}
