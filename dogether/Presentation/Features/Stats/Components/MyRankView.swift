//
//  MyRankView.swift
//  dogether
//
//  Created by yujaehong on 4/30/25.
//

import UIKit
import SnapKit

final class MyRankView: BaseView {
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .chart.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .grey0
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 순위"
        label.font = Fonts.body1S
        label.textColor = .grey0
        return label
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    private let rankBaseLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.body1S
        label.textColor = .grey200
        label.textAlignment = .center
        return label
    }()
    
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.emphasis2B
        label.textColor = .blue300
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func configureView() {
        backgroundColor = .grey800
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        addSubview(titleStackView)
        addSubview(rankBaseLabel)
        addSubview(rankLabel)
    }
    
    override func configureConstraints() {
        titleStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(25)
        }
        
        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        
        rankBaseLabel.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(33.5)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(25)
        }
        
        rankLabel.snp.makeConstraints {
            $0.top.equalTo(rankBaseLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(36)
        }
    }
}

extension MyRankView {
    func configure(count: Int, rank: Int) {
        rankBaseLabel.text = "\(count)명 중"
        rankLabel.text = "\(rank)등"
    }
}
