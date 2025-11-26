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
    private let emptyView = GroupEmptyView()
    private let scrollView = UIScrollView()
    private let scrollContentView = UIView()
    private var contentView: StatsContentView?
    private var errorView: ErrorView?
    private var bottomSheetViewController: BottomSheetViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchMyGroups()
    }

    override func configureAction() {
        navigationHeader.delegate = self
        viewModel.delegate = self
        
        emptyView.createButtonTapHandler = { [weak self] in
            guard let self else { return }
            coordinator?.pushViewController(GroupCreateViewController())
        }
    }

    override func configureHierarchy() {
        view.addSubview(navigationHeader)
        view.addSubview(emptyView)
    }

    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }

        emptyView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}

extension StatsViewController {
    private func displayViewForCurrentStatus() {
        switch viewModel.statsViewStatus {
        case .hasData:
            showStatsContentView()
        default:
            showEmptyState()
        }
    }
    
    private func showStatsContentView() {
        hideEmptyState()
        setupContentView()
        configureBottomSheetViewController()
    }
    
    private func showEmptyState() {
        emptyView.isHidden = false
    }
    
    private func hideEmptyState() {
        emptyView.isHidden = true
    }
}

extension StatsViewController {
    private func setupContentView() {
        let contentView = StatsContentView(viewModel: viewModel)
        self.contentView = contentView
        
        setupScrollViewHierarchy()
        setupConstraints(for: contentView)
        
        contentView.isHidden = false
        contentView.delegate = self
    }
    
    private func setupScrollViewHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
    }
    
    private func setupConstraints(for contentView: StatsContentView) {
        scrollContentView.addSubview(contentView)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension StatsViewController {
    private func configureBottomSheetViewController() {
        let bottomSheetItem = viewModel.groupSortOptions.map { $0.bottomSheetItem }
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
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            scrollView.removeFromSuperview()
            contentView?.removeFromSuperview()
            contentView = nil
            displayViewForCurrentStatus()
            errorView?.removeFromSuperview()
            errorView = nil
        }
    }
    
    func didFetchStatsFail(error: NetworkError) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            scrollView.removeFromSuperview()
            contentView?.removeFromSuperview()
            contentView = nil
            emptyView.isHidden = true
            errorView?.removeFromSuperview()
            
            let newErrorView = ErrorHandlingManager.embedErrorView(
                in: self,
                under: navigationHeader,
                error: error,
                retryHandler: { [weak self] in
                    guard let self else { return }
                    viewModel.fetchMyGroups()
                }
            )
            errorView = newErrorView
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
