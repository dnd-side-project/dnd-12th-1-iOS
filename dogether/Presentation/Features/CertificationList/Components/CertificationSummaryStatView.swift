//
//  CertificationSummaryStatView.swift
//  dogether
//
//  Created by yujaehong on 4/23/25.
//

import UIKit

final class CertificationSummaryStatView: BaseView {
    private let type: CertificationTypes
    
    init(type: CertificationTypes) {
        self.type = type
        
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let countLabel = UILabel()

    override func configureView() {
        backgroundColor = .grey700
        layer.cornerRadius = 12
        clipsToBounds = true
        
        imageView.image = type.iconImage
        imageView.contentMode = .scaleAspectFit
        
        titleLabel.text = type.text
        titleLabel.font = Fonts.body2S
        titleLabel.textColor = .grey200
        titleLabel.textAlignment = .center
        
        countLabel.font = Fonts.head2B
        countLabel.textColor = .grey0
        countLabel.textAlignment = .center
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [imageView, titleLabel, countLabel].forEach { addSubview($0) }
    }

    override func configureConstraints() {
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(107)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: String) {
        countLabel.text = data
    }
}
