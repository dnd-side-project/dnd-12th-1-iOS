//
//  CertificationListContentView.swift
//  dogether
//
//  Created by yujaehong on 4/23/25.
//

import UIKit

protocol CertificationListContentViewDelegate: AnyObject {
    func didTapFilter(selectedFilter: FilterTypes)
    func didTapCertification(title: String, todos: [TodoEntity], index: Int)
    func didScrollToBottom()
}

final class CertificationListContentView: BaseView {
    weak var delegate: CertificationListContentViewDelegate?
    private let viewModel: CertificationListViewModel
    private var isPagingRequestInProgress = false
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.font = Fonts.head1B
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var summaryView = CertificationSummaryView()
    
    let filterView = CertificationFilterView()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let spacing: CGFloat = 11
        let inset: CGFloat = 16
        let totalSpacing = spacing + inset * 2
        let itemWidth = (UIScreen.main.bounds.width - totalSpacing) / 2
        layout.itemSize = CGSize(width: itemWidth, height: 166)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    init(viewModel: CertificationListViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        self.summaryView.configure(totalCertificatedCount: viewModel.totalCertificatedCount,
                                   totalApprovedCount: viewModel.totalApprovedCount,
                                   totalRejectedCount: viewModel.totalRejectedCount)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func configureView() {
        collectionView.register(CertificationCell.self,
                                forCellWithReuseIdentifier: CertificationCell.reuseIdentifier)
        collectionView.register(CertificationSectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CertificationSectionHeader.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        setupHeaderLabelText()
    }
    
    override func configureAction() {
        filterView.filterSelected = { [weak self] filter in
            self?.delegate?.didTapFilter(selectedFilter: filter)
        }
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
    
    func makeContentOffset() {
        collectionView.contentOffset = .zero
    }
}

extension CertificationListContentView {
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension CertificationListContentView {
    func setupHeaderLabelText() {
        let count = viewModel.totalCertificatedCount
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
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.sections[section].certifications.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CertificationCell.reuseIdentifier, for: indexPath) as! CertificationCell
        let certification = viewModel.sections[indexPath.section].certifications[indexPath.item]
        cell.configure(with: certification)
        return cell
    }
}
   

extension CertificationListContentView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CertificationSectionHeader.reuseIdentifier,
            for: indexPath) as! CertificationSectionHeader
        
        let section = viewModel.sections[indexPath.section]
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = viewModel.sections[indexPath.section]
        let title: String
        
        switch section.type {
        case .daily(let dateString):
            title = dateString
        case .group(let groupName):
            title = groupName
        }
        
        let todos = section.certifications.map { TodoEntity(from: $0) }
        
        delegate?.didTapCertification(title: title, todos: todos, index: indexPath.item)
    }
}

extension CertificationListContentView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !viewModel.isLastPage else {
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
