//
//  CertificationListContentView.swift
//  dogether
//
//  Created by yujaehong on 4/23/25.
//

import UIKit

final class CertificationListContentView: BaseView {
    var delegate: CertificationListPageDelegate? {
        didSet {
            filterView.delegate = delegate
        }
    }
    
    private let headerLabel = UILabel()
    private let summaryView = CertificationSummaryView()
    private let filterView = CertificationFilterView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private(set) var currentStatsViewDatas: StatsViewDatas?
    private(set) var currentSection: [SectionEntity]?
    private(set) var currentFilter: FilterTypes?
    private(set) var currentIsLastPage: Bool = false
    
    private(set) var sections: [SectionEntity] = []
    private(set) var isPagingRequestInProgress: Bool = false
    
    override func configureView() {
        headerLabel.textColor = .grey0
        headerLabel.font = Fonts.head1B
        headerLabel.numberOfLines = 0
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.scrollDirection = .vertical
        let spacing: CGFloat = 12
        let inset: CGFloat = 16
        let totalSpacing = spacing + inset * 2
        let itemWidth = (UIScreen.main.bounds.width - totalSpacing) / 2
        layout.itemSize = CGSize(width: itemWidth, height: 166)
        
        collectionView.collectionViewLayout = layout
        collectionView.register(
            CertificationCell.self,
            forCellWithReuseIdentifier: CertificationCell.reuseIdentifier
        )
        collectionView.register(
            CertificationSectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CertificationSectionHeader.reuseIdentifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
    }
    
    override func configureHierarchy() {
        [headerLabel, summaryView, filterView, collectionView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        headerLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        summaryView.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        filterView.snp.makeConstraints {
            $0.top.equalTo(summaryView.snp.bottom).offset(32)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(filterView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
    
    override func updateView(_ data: any BaseEntity) {
        if let datas = data as? SortViewDatas {
            filterView.updateView(datas)
        }
        
        if let datas = data as? StatsViewDatas {
            if currentStatsViewDatas != datas {
                currentStatsViewDatas = datas
                
                setupHeaderLabelText(count: datas.achievementCount)
                summaryView.updateView(datas)
            }
        }
        
        if let datas = data as? CertificationListViewDatas {
            if currentSection != datas.sections || currentFilter != datas.filter {
                currentSection = datas.sections
                
                sections = datas.sections.compactMap { section in
                    let filteredTodos = section.todos.filter {
                        datas.filter == .all || datas.filter == FilterTypes(status: $0.status.rawValue)
                    }
                    return filteredTodos.isEmpty ? nil : SectionEntity(type: section.type, todos: filteredTodos)
                }
            }
            
            if currentFilter != datas.filter {
                currentFilter = datas.filter
                
                filterView.updateView(datas)
            }
            
            if currentIsLastPage != datas.isLastPage {
                currentIsLastPage = datas.isLastPage
            }
            
            collectionView.reloadData()
            collectionView.contentOffset = .zero
        }
    }
}

extension CertificationListContentView {
    private func setupHeaderLabelText(count: Int) {
        let fullText = "대단해요!\n총 \(count)개의 투두를 달성했어요"
        let attributedString = NSMutableAttributedString(string: fullText)
        let targetText = "\(count)개"
        
        if let range = fullText.range(of: targetText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.blue300, range: nsRange)
        }
        
        headerLabel.attributedText = attributedString
    }
}

extension CertificationListContentView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return sections[section].todos.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CertificationCell.reuseIdentifier,
            for: indexPath) as? CertificationCell else {
            return UICollectionViewCell()
        }
        
        let certification = sections[indexPath.section].todos[indexPath.item]
        cell.configure(with: certification)
        return cell
    }
}

extension CertificationListContentView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                  ofKind: kind,
                  withReuseIdentifier: CertificationSectionHeader.reuseIdentifier,
                  for: indexPath
              ) as? CertificationSectionHeader else {
            return UICollectionReusableView()
        }
        let section = sections[indexPath.section]
        
        let title: String
        switch section.type {
        case .daily(let dateString):
            title = dateString
        case .group(let groupName):
            title = groupName
        }
        
        header.configure(title: title)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
}

extension CertificationListContentView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let section = sections[indexPath.section]

        let title: String
        switch section.type {
        case .daily(let dateString):
            title = dateString
        case .group(let groupName):
            title = groupName
        }
        
        delegate?.selectCertificationAction(title: title, todos: section.todos, index: indexPath.item)
    }
}

extension CertificationListContentView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if currentIsLastPage {
            isPagingRequestInProgress = false
            return
        }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight - 100 {
            if !isPagingRequestInProgress {
                isPagingRequestInProgress = true
                delegate?.didScrollToBottom()
            }
        } else {
            isPagingRequestInProgress = false
        }
    }
}
