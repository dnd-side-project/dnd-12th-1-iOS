//
//  CertificationSectionHeader.swift
//  dogether
//
//  Created by yujaehong on 4/23/25.
//

import UIKit

final class CertificationSectionHeader: UICollectionReusableView {
    static let reuseIdentifier = "CertificationSectionHeader"

    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = .white
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(title: String) {
        titleLabel.text = title
    }
}
