//
//  CertificationSortButton.swift
//  dogether
//
//  Created by yujaehong on 5/19/25.
//

import UIKit

final class CertificationSortButton: BaseButton {
    private let sortTitleLabel = UILabel()
    private let arrowImageView = UIImageView(image: .chevronDownBlue)  // FIXME: 추후 아이콘 통일
    
    override func configureView() {
        backgroundColor = .clear
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor.grey500.cgColor
        clipsToBounds = true
        
        sortTitleLabel.font = Fonts.body2S
        sortTitleLabel.textColor = .white
        
        arrowImageView.contentMode = .scaleAspectFit
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [sortTitleLabel, arrowImageView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        snp.makeConstraints {
            $0.width.equalTo(116)
            $0.height.equalTo(32)
        }
        
        sortTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(16)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: any BaseEntity) {
        if let datas = data as? SortOptions {
            sortTitleLabel.text = datas.displayName
        }
    }
}
