//
//  RankingView.swift
//  dogether
//
//  Created by seungyooooong on 4/10/25.
//

import UIKit

final class RankingView: BaseView {
    init() {
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let rankingLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.font = Fonts.body2S
        return label
    }()
    
    private let profileImageView = RankingImageView(viewType: .tableView)
    
    private let nameLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.font = Fonts.body1S
        return label
    }()
    
    private let certificationImageView = UIImageView(image: .certification)
    
    private let certificationLabel = {
        let label = UILabel()
        label.textColor = .blue300
        label.font = Fonts.body2S
        return label
    }()
    
    override func configureView() { }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [rankingLabel, profileImageView, nameLabel, certificationImageView, certificationLabel].forEach { self.addSubview($0) }
    }
    
    override func configureConstraints() {
        self.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        rankingLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(rankingLabel.snp.right).offset(20)
            $0.width.height.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(profileImageView.snp.right).offset(12)
        }
        
        certificationImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(certificationLabel.snp.left).offset(-4)
            $0.width.height.equalTo(24)
        }
        
        certificationLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview()
            $0.width.equalTo(31)
        }
    }
}

extension RankingView {
    func setExtraInfo(ranking: RankingModel) {
        rankingLabel.text = String(ranking.rank)
        profileImageView.setReadStatus(readStatus: ranking.historyReadStatus)
        profileImageView.loadImage(url: ranking.profileImageUrl)
        nameLabel.text = ranking.name
        certificationLabel.text = "\(ranking.achievementRate)%"
    }
}
