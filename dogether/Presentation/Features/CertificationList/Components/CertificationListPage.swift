//
//  CertificationListPage.swift
//  dogether
//
//  Created by yujaehong on 12/8/25.
//

import UIKit

final class CertificationListPage: BasePage {
    var delegate: CertificationListPageDelegate? {
        didSet {
            contentView.delegate = delegate
            
            bottomSheetView.certificationDelegate = delegate
        }
    }
    
    private let navigationHeader = NavigationHeader(title: "인증 목록")
    private let emptyView = CertificationListEmptyView()
    private let contentView = CertificationListContentView()
    private let bottomSheetView = BottomSheetView(hasAddButton: false)
    
    override func configureView() { }
    
    override func configureAction() {
        navigationHeader.delegate = coordinatorDelegate
    }
    
    override func configureHierarchy() {
        [navigationHeader, emptyView, contentView, bottomSheetView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
        bottomSheetView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func updateView(_ data: any BaseEntity) {
        if let datas = data as? BottomSheetViewDatas {
            bottomSheetView.updateView(datas)
        }
        
        if let datas = data as? SortViewDatas {
            contentView.updateView(datas)
            bottomSheetView.updateView(datas)
        }
        
        if let datas = data as? StatsViewDatas {
            contentView.updateView(datas)
        }

        if let datas = data as? CertificationListViewDatas {
            emptyView.isHidden = !datas.sections.isEmpty
            contentView.isHidden = datas.sections.isEmpty
            
            contentView.updateView(datas)
        }
    }
}
