//
//  EmptyStateView.swift
//  dogether
//
//  Created by yujaehong on 4/22/25.
//

import UIKit
import SnapKit

final class EmptyStateView: BaseView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: .embarrassedDosik)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.head2B
        label.textColor = .grey200
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.body2R
        label.textColor = .grey400
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let title: String
    private let descriptionText: String
    
    init(title: String, description: String) {
        self.title = title
        self.descriptionText = description
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureView() {
        backgroundColor = .clear
        titleLabel.text = title
        descriptionLabel.text = descriptionText
    }
    
    override func configureHierarchy() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
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
