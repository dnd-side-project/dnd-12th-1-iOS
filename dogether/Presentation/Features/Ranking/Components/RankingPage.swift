//
//  RankingPage.swift
//  dogether
//
//  Created by seungyooooong on 10/11/25.
//

import UIKit

final class RankingPage: BasePage {
    var delegate: RankingDelegate?
    
    private let navigationHeader = NavigationHeader(title: "순위")
    private let rankingTopStackView = UIStackView()
    private let descriptionView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.grey600.cgColor
        view.layer.borderWidth = 1
        
        let imageView = UIImageView(image: .notice)
        
        let label = UILabel()
        label.text = "달성률은 인증, 인정, 참여 기간을 기준으로 계산돼요."
        label.textColor = .grey400
        label.font = Fonts.body2S
        
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        [stackView].forEach { view.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        return view
    }()
    private let rankingTableView = UITableView()
    
//    private var errorView: ErrorView?
    
    private(set) var currentRankings: [RankingEntity]?
    
    override func configureView() {
        rankingTopStackView.axis = .horizontal
        rankingTopStackView.spacing = 11
        rankingTopStackView.distribution = .fillEqually
        
        rankingTableView.backgroundColor = .clear
        rankingTableView.separatorStyle = .none
        rankingTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func configureAction() {
        navigationHeader.delegate = coordinatorDelegate
        
        rankingTableView.delegate = self
        rankingTableView.dataSource = self
        rankingTableView.register(RankingTableViewCell.self, forCellReuseIdentifier: RankingTableViewCell.identifier)
    }
    
    override func configureHierarchy() {
        [navigationHeader, rankingTopStackView, descriptionView, rankingTableView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        rankingTopStackView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(190)
        }
        
        descriptionView.snp.makeConstraints {
            $0.top.equalTo(rankingTopStackView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        
        rankingTableView.snp.makeConstraints {
            $0.top.equalTo(descriptionView.snp.bottom).offset(16)
            $0.bottom.left.right.equalToSuperview()
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? RankingViewDatas {
            if currentRankings != datas.rankings {
                currentRankings = datas.rankings
                
                rankingTopStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

                [1, 0, 2].forEach { index in
                    let ranking = datas.rankings[safe: index]
                    let topView = RankingTopView(ranking: ranking, index: index)
                    topView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedTopView(_:))))
                    rankingTopStackView.addArrangedSubview(topView)
                }

                rankingTableView.reloadData()
            }
        }
    }
}

// MARK: - aboout tableView
extension RankingPage: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currentRankings, currentRankings.count > 3 else { return 0 }
        return currentRankings.count - 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentRankings, let cell = tableView.dequeueReusableCell(
            withIdentifier: RankingTableViewCell.identifier,
            for: indexPath
        ) as? RankingTableViewCell else { return UITableViewCell() }
        
        cell.setExtraInfo(ranking: currentRankings[indexPath.row + 3])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goMemberCertificationView(rankingIndex: indexPath.row + 3)
    }
}

extension RankingPage {
    @objc private func tappedTopView(_ sender: UITapGestureRecognizer) {
        guard let rankingTopView = sender.view as? RankingTopView, let ranking = rankingTopView.ranking else { return }
        
        goMemberCertificationView(rankingIndex: ranking.rank - 1)
    }
    
    private func goMemberCertificationView(rankingIndex: Int) {
        guard let currentRankings, let _ = currentRankings[rankingIndex].historyReadStatus else { return }
        
        delegate?.goCertificationViewAction(rankingEntity: currentRankings[rankingIndex])
    }
}
