//
//  RankingViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/14/25.
//

import UIKit
import SnapKit

final class RankingViewController: BaseViewController {
    var viewModel = RankingViewModel()
    
    private let navigationHeader = NavigationHeader(title: "순위")
    
    private var rankingTopStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 11
        stackView.distribution = .fillEqually
        return stackView
    }()
    
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
    
    private let rankingTableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private var errorView: ErrorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coordinator?.updateViewController = loadRankingView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadRankingView()
    }
    
    override func configureView() {
        updateView()
    }
    
    override func configureAction() {
        navigationHeader.delegate = self
        
        rankingTableView.delegate = self
        rankingTableView.dataSource = self
        rankingTableView.register(RankingTableViewCell.self, forCellReuseIdentifier: RankingTableViewCell.identifier)
    }
    
    override func configureHierarchy() {
        [navigationHeader, rankingTopStackView, descriptionView, rankingTableView].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
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
}

extension RankingViewController {
    private func loadRankingView() {
        Task { [weak self] in
            guard let self else { return }
            do {
                try await viewModel.loadRankingView()
                await MainActor.run {
                    self.showMainContentViews()
                    self.updateView()
                }
            } catch let error as NetworkError {
                await MainActor.run {
                    self.hideMainContentViews()
                    self.showErrorView(error: error)
                }
            }
        }
    }
    
    private func updateView() {
        rankingTopStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        [1, 0, 2].forEach { index in
            let ranking = viewModel.rankings[safe: index]
            let topView = RankingTopView(ranking: ranking)
            topView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedTopView(_:))))
            rankingTopStackView.addArrangedSubview(topView)
        }
        
        rankingTableView.reloadData()
    }
}

// MARK: - aboout tableView
extension RankingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard viewModel.rankings.count > 3 else { return 0 }
        return viewModel.rankings.count - 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RankingTableViewCell.identifier,
            for: indexPath
        ) as? RankingTableViewCell else { return UITableViewCell() }
        
        cell.setExtraInfo(ranking: viewModel.rankings[indexPath.row + 3])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goMemberCertificationView(rankingIndex: indexPath.row + 3)
    }
}

extension RankingViewController {
    @objc private func tappedTopView(_ sender: UITapGestureRecognizer) {
        if let rankingTopView = sender.view as? RankingTopView, let ranking = rankingTopView.ranking {
            goMemberCertificationView(rankingIndex: ranking.rank - 1)
        }
    }
    
    private func goMemberCertificationView(rankingIndex: Int) {
        if viewModel.rankings[rankingIndex].historyReadStatus == nil { return }
        
        let memberCertificationViewController = MemberCertificationViewController()
        memberCertificationViewController.viewModel.groupId = viewModel.groupId
        memberCertificationViewController.viewModel.memberInfo = viewModel.rankings[rankingIndex]
        coordinator?.pushViewController(memberCertificationViewController)
    }
}

// MARK: - ErrorView
extension RankingViewController {
    private func showErrorView(error: NetworkError) {
        errorView?.removeFromSuperview()
        errorView = ErrorHandlingManager.embedErrorView(
            in: self,
            under: navigationHeader,
            error: error,
            retryHandler: { [weak self] in
                guard let self else { return }
                loadRankingView()
            }
        )
    }
    
    private func showMainContentViews() {
        [rankingTopStackView, descriptionView, rankingTableView].forEach {
            $0.isHidden = false
        }
        errorView = nil
    }
    
    private func hideMainContentViews() {
        [rankingTopStackView, descriptionView, rankingTableView].forEach {
            $0.isHidden = true
        }
    }
}
