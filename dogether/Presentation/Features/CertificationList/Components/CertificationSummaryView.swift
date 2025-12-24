//
//  CertificationSummaryView.swift
//  dogether
//
//  Created by yujaehong on 4/23/25.
//

import UIKit

final class CertificationSummaryView: BaseView {
    private let stackView = UIStackView()
    private let achievedView = CertificationSummaryStatView(type: .achievement)
    private let certifiedView = CertificationSummaryStatView(type: .approve)
    private let notCertifiedView = CertificationSummaryStatView(type: .reject)

    override func configureView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 11
    }
    
    override func configureAction() { }

    override func configureHierarchy() {
        [achievedView, certifiedView, notCertifiedView].forEach { stackView.addArrangedSubview($0) }
        
        addSubview(stackView)
    }

    override func configureConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func updateView(_ data: any BaseEntity) {
        guard let datas = data as? StatsViewDatas else { return }
        achievedView.updateView("\(datas.achievementCount)개")
        certifiedView.updateView("\(datas.approveCount)개")
        notCertifiedView.updateView("\(datas.rejectCount)개")
    }
}
