//
//  CertificationListEmptyView.swift
//  dogether
//
//  Created by yujaehong on 4/23/25.
//

import UIKit

final class CertificationListEmptyView: BaseView {
    private let emptyStateView = EmptyStateView(
        title: "아직 작성된 투두가 없어요",
        description: "오늘 하루 이루고 싶은 목표를 입력해보세요!"
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func configureView() {
        backgroundColor = .clear
    }
    
    override func configureAction() {
    }
    
    override func configureHierarchy() {
        addSubview(emptyStateView)
    }
    
    override func configureConstraints() {
        emptyStateView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(160)
            $0.centerX.equalToSuperview()
        }
    }
}
