//
//  CertificationListViewController.swift
//  dogether
//
//  Created by yujaehong on 4/21/25.
//

final class CertificationListViewController: BaseViewController {
    private let certificationListPage = CertificationListPage()
    private let viewModel = CertificationListViewModel()
    
    override func viewDidLoad() {
        certificationListPage.delegate = self
        
        pages = [certificationListPage]
        
        super.viewDidLoad()
        
        onAppear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // FIXME: 추후에 API 세분화 되면 Stats API만 updateViewController 지정, 호출 필요 x
//        coordinator?.updateViewController = loadSummaryView
    }
    
    override func setViewDatas() {
        bind(viewModel.bottomSheetViewDatas)
        bind(viewModel.sortViewDatas)
        bind(viewModel.statsViewDatas)
        bind(viewModel.certificationListViewDatas)
    }
}

extension CertificationListViewController {
    private func onAppear() {
        loadCertificationListView()
    }
    
    private func loadCertificationListView(page: Int = 0) {
        Task { [weak self] in
            guard let self else { return }
            try await viewModel.loadCertificationList(page: page)
        }
    }
}

protocol CertificationListPageDelegate {
    func updateBottomSheetVisibleAction(isShowSheet: Bool)
    func selectSortAction(index: Int)
    func selectFilterAction(filterType: FilterTypes)
    func selectCertificationAction(title: String, todos: [TodoEntity], index: Int)
    func didScrollToBottom()
}

extension CertificationListViewController: CertificationListPageDelegate {
    func updateBottomSheetVisibleAction(isShowSheet: Bool) {
        viewModel.bottomSheetViewDatas.update { $0.isShowSheet = isShowSheet }
    }
    
    func selectSortAction(index: Int) {
        viewModel.updateSortIndex(index: index)
        
        loadCertificationListView()
    }
    
    func selectFilterAction(filterType: FilterTypes) {
        viewModel.updateFilter(filter: filterType)
    }
    
    func selectCertificationAction(title: String, todos: [TodoEntity], index: Int) {
        let certificationViewController = CertificationViewController()
        let certificationViewDatas = CertificationViewDatas(title: title, todos: todos, index: index)
        coordinator?.pushViewController(certificationViewController, datas: certificationViewDatas)
    }
    
    func didScrollToBottom() {
        loadCertificationListView(page: viewModel.certificationListViewDatas.value.currentPage + 1)
    }
}
