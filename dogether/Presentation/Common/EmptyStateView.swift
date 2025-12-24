//
//  EmptyStateView.swift
//  dogether
//
//  Created by yujaehong on 4/22/25.
//

import UIKit
import SnapKit

final class EmptyStateView: BaseView {
    private let imageView = UIImageView(image: .embarrassedDosik)
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let title: String
    private let descriptionText: String
    
    init(title: String, description: String) {
        self.title = title
        self.descriptionText = description
        
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func configureView() {
        backgroundColor = .clear
        
        imageView.contentMode = .scaleAspectFit
        
        titleLabel.text = title
        titleLabel.font = Fonts.head2B
        titleLabel.textColor = .grey200
        titleLabel.textAlignment = .center
        
        descriptionLabel.text = descriptionText
        descriptionLabel.font = Fonts.body2R
        descriptionLabel.textColor = .grey400
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 2
    }
    
    override func configureHierarchy() {
        [imageView, titleLabel, descriptionLabel].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(129)
            $0.height.equalTo(148)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(17)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
}
