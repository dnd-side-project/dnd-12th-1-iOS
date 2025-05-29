//
//  RankingTopView.swift
//  dogether
//
//  Created by seungyooooong on 2/14/25.
//

import UIKit
import SnapKit

final class RankingTopView: BaseView {
    let ranking: RankingModel?
    
    init(ranking: RankingModel?) {
        self.ranking = ranking
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let rankingView = {
        let view = UIView()
        view.backgroundColor = .grey700
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let rankingImageView = UIImageView()
    private let profileImageView = RankingImageView(viewType: .topView)
    
    private let nameLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.font = Fonts.body1B
        return label
    }()
    
    private let certificationLabel = {
        let label = UILabel()
        label.textColor = .blue300
        label.font = Fonts.body2S
        return label
    }()
    
    private let emptyProfileView = {
        let view = UIView()
        view.layer.cornerRadius = 26
        view.layer.borderColor = UIColor.grey600.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let emptyNameLabel = {
        let label = UILabel()
        label.text = "-"
        label.textColor = .grey400
        label.font = Fonts.body1B
        return label
    }()
    
    private let emptyCertificationLabel = {
        let label = UILabel()
        label.text = "-"
        label.textColor = .grey400
        label.font = Fonts.body2S
        return label
    }()

    override func configureView() {
        if let ranking {
            rankingImageView.image = ranking.rank == 1 ? .crown1 : ranking.rank == 2 ? .crown2 : .crown3
            profileImageView.setReadStatus(readStatus: ranking.historyReadStatus)
            profileImageView.loadImage(url: ranking.profileImageUrl)
            nameLabel.text = ranking.name
            certificationLabel.text = "달성률 \(ranking.achievementRate)%"
        }
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        if ranking != nil {
            [rankingView, rankingImageView].forEach { addSubview($0) }
            [profileImageView, nameLabel, certificationLabel].forEach { rankingView.addSubview($0) }
        } else {
            [rankingView].forEach { addSubview($0) }
            [emptyProfileView, emptyNameLabel, emptyCertificationLabel].forEach { rankingView.addSubview($0) }
        }
    }
    
    override func configureConstraints() {
        if let ranking {
            rankingView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(ranking.rank == 1 ? 20 : 40)
                $0.width.equalTo(107)
                $0.height.equalTo(158)
            }
            
            rankingImageView.snp.makeConstraints {
                $0.centerX.equalToSuperview()   // TODO: 살짝 오른쪽으로 치우쳐진 느낌이 드는데 추후 확인 필요
                $0.centerY.equalTo(rankingView.snp.top)
                $0.width.height.equalTo(36)
            }
            
            profileImageView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(20)
                $0.width.height.equalTo(60)
            }
            
            nameLabel.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(profileImageView.snp.bottom).offset(12)
                $0.height.equalTo(25)
            }
            
            certificationLabel.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(nameLabel.snp.bottom)
                $0.height.equalTo(21)
            }
        } else {
            rankingView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(40)
                $0.width.equalTo(107)
                $0.height.equalTo(158)
            }
            
            emptyProfileView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(20)
                $0.width.height.equalTo(60)
            }
            
            emptyNameLabel.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(emptyProfileView.snp.bottom).offset(12)
                $0.height.equalTo(25)
            }
            
            emptyCertificationLabel.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(emptyNameLabel.snp.bottom)
                $0.height.equalTo(21)
            }
        }
    }
}
