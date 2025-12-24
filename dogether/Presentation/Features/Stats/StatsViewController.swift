//
//  StatsViewController.swift
//  dogether
//
//  Created by yujaehong on 4/21/25.
//

import UIKit

final class StatsViewController: BaseViewController {
    private let statsPage = StatsPage()
    private let viewModel = StatsViewModel()

    override func viewDidLoad() {
        statsPage.delegate = self
        
        pages = [statsPage]
        
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadStatsView()
        
        coordinator?.updateViewController = loadStatsView
    }

    override func setViewDatas() {
        bind(viewModel.bottomSheetViewDatas)
        bind(viewModel.groupViewDatas)
        bind(viewModel.achievementViewDatas)
        bind(viewModel.myRankViewDatas)
        bind(viewModel.summaryViewDatas)
    }
}

extension StatsViewController {
    private func loadStatsView() {
        Task { [weak self] in
            guard let self else { return }
            try await viewModel.loadStatsView()
        }
    }
    
    private func reloadStats() {
        Task { [weak self] in
            guard let self else { return }
            try await viewModel.fetchStatsViewDatas()
        }
    }
}

protocol StatsDelegate {
    func updateBottomSheetVisibleAction(isShowSheet: Bool)
    func selectGroupAction(index: Int)
    func addGroupAction()
}

extension StatsViewController: StatsDelegate {
    func updateBottomSheetVisibleAction(isShowSheet: Bool) {
        viewModel.bottomSheetViewDatas.update { $0.isShowSheet = isShowSheet }
    }
    
    func selectGroupAction(index: Int) {
        viewModel.groupViewDatas.update { $0.index = index }
        viewModel.saveLastSelectedGroupIndex(index: index)
        
        reloadStats()
    }
    
    func addGroupAction() {
        coordinator?.pushViewController(GroupCreateViewController())
    }
}
