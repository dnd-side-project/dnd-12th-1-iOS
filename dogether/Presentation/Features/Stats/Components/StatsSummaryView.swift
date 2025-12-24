//
//  StatsSummaryView.swift
//  dogether
//
//  Created by yujaehong on 4/30/25.
//

import UIKit
import SnapKit

final class StatsSummaryView: BaseView {
    private let titleIconImageView = UIImageView(image: .summary)
    private let titleLabel = UILabel()
    private let titleStackView = UIStackView()
    
    private let achievedStackView = StatsSummaryStackView(type: .achievement)
    private let approveStackView = StatsSummaryStackView(type: .approve)
    private let rejectStackView = StatsSummaryStackView(type: .reject)
    
    private let summaryStackView = UIStackView()
    
    override func configureView() {
        backgroundColor = .grey800
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        titleIconImageView.image = .summary
        titleIconImageView.contentMode = .scaleAspectFit
        
        titleLabel.text = "요약"
        titleLabel.font = Fonts.body1S
        titleLabel.textColor = .grey0
        
        titleStackView.axis = .horizontal
        titleStackView.spacing = 4
        titleStackView.alignment = .center
        
        summaryStackView.axis = .vertical
        summaryStackView.spacing = 8
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [titleIconImageView, titleLabel].forEach { titleStackView.addArrangedSubview($0) }
        [achievedStackView, approveStackView, rejectStackView].forEach { summaryStackView.addArrangedSubview($0) }
        
        [titleStackView, summaryStackView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        titleIconImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        titleStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(25)
        }
        
        summaryStackView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(88)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        guard let datas = data as? StatsSummaryViewDatas else { return }
        
        achievedStackView.updateView("\(datas.certificatedCount)개")
        approveStackView.updateView("\(datas.approvedCount)개")
        rejectStackView.updateView("\(datas.rejectedCount)개")
    }
}
