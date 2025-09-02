//
//  CertificationListViewModel.swift
//  dogether
//
//  Created by yujaehong on 4/23/25.
//

import UIKit

protocol CertificationListViewModelDelegate: AnyObject {
    func updateContentView()
    func didFetchFail(error: NetworkError)
}

final class CertificationListViewModel {
    
    private let useCase: CertificationListUseCase
    weak var delegate: CertificationListViewModelDelegate?
    
    private var rawSections: [CertificationSection] = []
    var sections: [CertificationSection] = []
    
    var viewStatus: CertificationListViewStatus = .empty
    
    var totalCertificatedCount: Int = 0
    var totalApprovedCount: Int = 0
    var totalRejectedCount: Int = 0
    private var currentPage: Int = 0
    var isLastPage: Bool = false
    
    var currentFilter: FilterTypes = .all {
        didSet {
            applyFilter()
        }
    }

    var selectedGroup: CertificationSortOption? = CertificationSortOption.allCases.first

    init() {
        let repository = DIManager.shared.getCertificationListRepository()
        self.useCase = CertificationListUseCase(repository: repository)
    }
}

extension CertificationListViewModel {
    func executeSort(option: CertificationSortOption) {
        currentPage = 0
        isLastPage = false
        
        Task {
            do {
                let result = try await useCase.fetchSortedList(option: option, page: currentPage)
                rawSections = result.sections
                totalCertificatedCount = result.stats.totalCertificatedCount
                totalApprovedCount = result.stats.totalApprovedCount
                totalRejectedCount = result.stats.totalRejectedCount
                isLastPage = !result.hasNext
                applyFilter()
                viewStatus = sections.isEmpty ? .empty : .hasData
            } catch let error as NetworkError {
                delegate?.didFetchFail(error: error)
            }
        }
    }
    
    private func applyFilter() {
        sections = rawSections.compactMap { section in
            let filtered = section.certifications.filter { cert in
                guard let filterType = FilterTypes(status: cert.status) else { return false }
                return currentFilter == .all || currentFilter == filterType
            }
            return filtered.isEmpty ? nil : CertificationSection(type: section.type, certifications: filtered)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.updateContentView()
        }
    }
    
    func loadNextPage() {
        guard !isLastPage else { return }
        guard let option = selectedGroup else { return }
        currentPage += 1
        
        Task {
            do {
                let result = try await useCase.fetchSortedList(option: option, page: currentPage)
                rawSections.append(contentsOf: result.sections)
                totalCertificatedCount = result.stats.totalCertificatedCount
                totalApprovedCount = result.stats.totalApprovedCount
                totalRejectedCount = result.stats.totalRejectedCount
                isLastPage = !result.hasNext
                applyFilter()
            } catch let error as NetworkError {
                delegate?.didFetchFail(error: error)
                currentPage -= 1
            }
        }
    }
}
