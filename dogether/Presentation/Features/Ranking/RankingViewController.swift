//
//  RankingViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/14/25.
//

import UIKit

final class RankingViewController: BaseViewController {
    private let rankingPage = RankingPage()
    private let viewModel = RankingViewModel()
    
    override func viewDidLoad() {
        rankingPage.delegate = self
        
        pages = [rankingPage]
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadRankingView()
        
        coordinator?.updateViewController = loadRankingView
    }
    
    override func setViewDatas() {
        guard let datas = datas as? RankingViewDatas else { return }
        viewModel.rankingViewDatas.accept(datas)
        
        bind(viewModel.rankingViewDatas)
    }
}

extension RankingViewController {
    private func loadRankingView() {
        Task { [weak self] in
            guard let self else { return }
            try await viewModel.loadRankingView()
        }
    }
}

// MARK: - delegate
protocol RankingDelegate {
    func goCertificationViewAction(rankingEntity: RankingEntity)
}

extension RankingViewController: RankingDelegate {
    func goCertificationViewAction(rankingEntity: RankingEntity) {
        Task {
            let (index, todos) = try await viewModel.getMemberTodos(memberId: rankingEntity.memberId)
            
            await MainActor.run {
                let certificationViewController = CertificationViewController()
                let certificationViewDatas = CertificationViewDatas(
                    title: "\(rankingEntity.name)님의 인증 정보",
                    todos: todos,
                    index: index,
                    groupId: viewModel.rankingViewDatas.value.groupId,
                    rankingEntity: rankingEntity
                )
                coordinator?.pushViewController(certificationViewController, datas: certificationViewDatas)
            }
        }
    }
}
