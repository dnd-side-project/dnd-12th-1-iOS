//
//  CertificationListViewModel.swift
//  dogether
//
//  Created by yujaehong on 4/23/25.
//

import RxRelay

final class CertificationListViewModel {
    private let userUseCase: UserUseCase
    
    private(set) var bottomSheetViewDatas = BehaviorRelay<BottomSheetViewDatas>(value: BottomSheetViewDatas())
    private(set) var statsViewDatas = BehaviorRelay<StatsViewDatas>(value: StatsViewDatas())
    private(set) var sortViewDatas = BehaviorRelay<SortViewDatas>(value: SortViewDatas())
    private(set) var certificationListViewDatas = BehaviorRelay<CertificationListViewDatas>(
        value: CertificationListViewDatas()
    )
    
    init() {
        let repository = DIManager.shared.getUserRepository()
        self.userUseCase = UserUseCase(repository: repository)
    }
}

extension CertificationListViewModel {
    func updateSortIndex(index: Int) {
        sortViewDatas.update { $0.index = index }
    }
    
    func updateFilter(filter: FilterTypes) {
        let filter: FilterTypes = (certificationListViewDatas.value.filter == filter) ? .all : filter
        certificationListViewDatas.update { $0.filter = filter }
    }
}

extension CertificationListViewModel {
    func loadCertificationList(page: Int) async throws {
        if page > 0 && certificationListViewDatas.value.isLastPage { return }
        try await fetchCertificationListViewDatas(page: page)
    }
}

extension CertificationListViewModel {
    private func fetchCertificationListViewDatas(page: Int) async throws {
        let (statsViewDatas, certificationListViewDatas) = try await userUseCase.getCertificationListViewDatas(
            option: sortViewDatas.value.options[sortViewDatas.value.index],
            page: page
        )
        
        self.statsViewDatas.accept(statsViewDatas)
        self.certificationListViewDatas.update {
            let newSections = certificationListViewDatas.sections
            $0.sections = page == 0 ? newSections : $0.sections + newSections
            $0.currentPage = page
            $0.isLastPage = certificationListViewDatas.isLastPage
        }
    }
}
