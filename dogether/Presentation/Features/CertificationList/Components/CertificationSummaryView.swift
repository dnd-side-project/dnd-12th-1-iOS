//
//  CertificationSummaryView.swift
//  dogether
//
//  Created by yujaehong on 4/23/25.
//

import UIKit

final class CertificationSummaryView: BaseView {
    private let stackView = UIStackView()
    private let achievedView = CertificationSummaryStatView(icon: .certificationGray, title: "달성")
    private let certifiedView = CertificationSummaryStatView(icon: .approve, title: "인정")
    private let notCertifiedView = CertificationSummaryStatView(icon: .reject, title: "노인정")
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) { fatalError() }

    override func configureView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 11
    }
    
    override func configureAction() {
    }

    override func configureHierarchy() {
        [achievedView, certifiedView, notCertifiedView].forEach { stackView.addArrangedSubview($0) }
        addSubview(stackView)
    }

    override func configureConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension CertificationSummaryView {
    func configure(totalCertificatedCount: Int,
                   totalApprovedCount: Int,
                   totalRejectedCount: Int) {
        achievedView.countLabel.text = "\(totalCertificatedCount)개"
        certifiedView.countLabel.text = "\(totalApprovedCount)개"
        notCertifiedView.countLabel.text = "\(totalRejectedCount)개"
    }
}
