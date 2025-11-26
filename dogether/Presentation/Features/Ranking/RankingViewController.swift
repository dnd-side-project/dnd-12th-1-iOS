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
        
        coordinator?.updateViewController = loadRankingView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadRankingView()
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
            do {
                try await viewModel.loadRankingView()
                await MainActor.run {
                    self.showMainContentViews()
                }
            } catch let error as NetworkError {
                await MainActor.run {
                    self.hideMainContentViews()
                    self.showErrorView(error: error)
                }
            }
        }
    }
}

// MARK: - ErrorView
extension RankingViewController {
    private func showErrorView(error: NetworkError) {
//        errorView?.removeFromSuperview()
//        errorView = ErrorHandlingManager.embedErrorView(
//            in: self,
//            under: navigationHeader,
//            error: error,
//            retryHandler: { [weak self] in
//                guard let self else { return }
//                loadRankingView()
//            }
//        )
    }
    
    private func showMainContentViews() {
//        [rankingTopStackView, descriptionView, rankingTableView].forEach {
//            $0.isHidden = false
//        }
//        errorView = nil
    }
    
    private func hideMainContentViews() {
//        [rankingTopStackView, descriptionView, rankingTableView].forEach {
//            $0.isHidden = true
//        }
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
