//
//  StatsRankView.swift
//  dogether
//
//  Created by yujaehong on 4/30/25.
//

import UIKit
import SnapKit

final class StatsRankView: BaseView {
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let titleStackView = UIStackView()
    private let rankBaseLabel = UILabel()
    private let rankLabel = UILabel()
    
    override func configureView() {
        backgroundColor = .grey800
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        iconImageView.image = .chart.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = .grey0
        iconImageView.contentMode = .scaleAspectFit
        
        titleLabel.text = "내 순위"
        titleLabel.font = Fonts.body1S
        titleLabel.textColor = .grey0
        
        titleStackView.axis = .horizontal
        titleStackView.spacing = 8
        titleStackView.alignment = .center
        
        rankBaseLabel.font = Fonts.body1S
        rankBaseLabel.textColor = .grey200
        rankBaseLabel.textAlignment = .center
        
        rankLabel.font = Fonts.emphasis2B
        rankLabel.textColor = .blue300
        rankLabel.textAlignment = .center
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [iconImageView, titleLabel].forEach { titleStackView.addArrangedSubview($0) }
        
        [titleStackView, rankBaseLabel, rankLabel].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        titleStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(25)
        }
        
        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
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
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        guard let datas = data as? StatsRankViewDatas else { return }
        rankBaseLabel.text = "\(datas.totalMembers)명 중"
        rankLabel.text = "\(datas.myRank)등"
    }
}
