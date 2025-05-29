//
//  StatsViewController.swift
//  dogether
//
//  Created by yujaehong on 4/21/25.
//

import UIKit

final class StatsViewController: BaseViewController {
    var viewModel = StatsViewModel()
    private let navigationHeader = NavigationHeader(title: "통계")
    private let statsEmptyView = GroupEmptyView()
    private var statsContentView: StatsContentView?
    
    private var bottomSheetViewController: BottomSheetViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchMyGroups()
    }

    override func configureAction() {
        navigationHeader.delegate = self
        viewModel.delegate = self
        
        statsEmptyView.createButtonTapHandler = { [weak self] in
            guard let self else { return }
            coordinator?.pushViewController(GroupCreateViewController())
        }
    }

    override func configureHierarchy() {
        view.addSubview(navigationHeader)
        view.addSubview(statsEmptyView)
    }

    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }

        statsEmptyView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}

extension StatsViewController {
    private func displayViewForCurrentStatus() {
        if viewModel.statsViewStatus == .hasData,
           statsContentView == nil {
            let contentView = StatsContentView(viewModel: viewModel)
            self.statsContentView = contentView
            view.addSubview(contentView)
            contentView.snp.makeConstraints {
                $0.top.equalTo(navigationHeader.snp.bottom)
                $0.left.right.bottom.equalToSuperview()
            }
            statsContentView?.isHidden = false
            
            configureBottomSheetViewController()
        }
    }
    
    private func configureBottomSheetViewController() {
        let bottomSheetItem = viewModel.groupSortOptions.map { $0.bottomSheetItem }
        // 선택된 그룹이 있는 경우 해당 항목 찾기
        let selectedItem = viewModel.selectedGroup?.bottomSheetItem
        
        guard !bottomSheetItem.isEmpty else { return }
        
        bottomSheetViewController = BottomSheetViewController(
            titleText: "그룹 선택",
            bottomSheetItem: bottomSheetItem,
            selectedItem: selectedItem
        )
        
        bottomSheetViewController?.modalPresentationStyle = .overCurrentContext
        bottomSheetViewController?.modalTransitionStyle = .coverVertical
        
        bottomSheetViewController?.didSelectOption = { [weak self] selectedItem in
            guard let self,
                  let selectedGroup = selectedItem.value as? GroupSortOption else { return }
            viewModel.fetchStatsForSelectedGroup(selectedGroup)
        }
    }
}

extension StatsViewController: StatsViewModelDelegate {
    func didFetchStatsSucceed() {
        DispatchQueue.main.async {
            self.statsContentView?.removeFromSuperview()
            self.statsContentView = nil
            self.displayViewForCurrentStatus()
            self.statsContentView?.delegate = self
        }
    }
}

extension StatsViewController: BottomSheetDelegate {
    func presentBottomSheet() {
        if presentedViewController == nil,
           let bottomSheetViewController {
            present(bottomSheetViewController, animated: true)
        }
    }
}
