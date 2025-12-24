//
//  CertificationFilterView.swift
//  dogether
//
//  Created by yujaehong on 5/19/25.
//

import UIKit

final class CertificationFilterView: BaseView {
    var delegate: CertificationListPageDelegate? {
        didSet {
            sortButton.addTapAction { [weak self] _ in
                guard let self else { return }
                delegate?.updateBottomSheetVisibleAction(isShowSheet: true)
            }
            
            filterStackView.certificationListDelegate = delegate
        }
    }
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let sortButton = CertificationSortButton()
    private let filterStackView = FilterStackView()
    
    override func configureView() {
        scrollView.showsHorizontalScrollIndicator = false
        
        stackView.axis = .horizontal
        stackView.spacing = 8
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        addSubview(scrollView)
        
        scrollView.addSubview(stackView)
        
        [sortButton, filterStackView].forEach { stackView.addArrangedSubview($0) }
    }
    
    override func configureConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        stackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalToSuperview()
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: any BaseEntity) {
        if let datas = data as? SortViewDatas {
            sortButton.updateView(datas.options[datas.index])
        }
        
        if let datas = data as? CertificationListViewDatas {
            filterStackView.updateView(datas.filter)
        }
    }
}
