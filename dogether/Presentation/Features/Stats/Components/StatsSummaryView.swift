//
//  StatsSummaryView.swift
//  dogether
//
//  Created by yujaehong on 4/30/25.
//

import UIKit
import SnapKit

final class StatsSummaryView: BaseView {
    private let titleIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "chart3")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "요약"
        label.font = Fonts.body1S
        label.textColor = .grey0
        return label
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleIconImageView, titleLabel])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    // 달성 Row
    private let achievedIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "certification2")
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { $0.size.equalTo(24) }
        return imageView
    }()
    
    private let achievedTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "달성"
        label.font = Fonts.body2S
        label.textColor = .grey200
        label.snp.makeConstraints { $0.width.equalTo(25) }
        return label
    }()
    
    private let certificatedCountLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.body2S
        label.textColor = .grey0
        return label
    }()
    
    private lazy var achievedStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [achievedIconImageView, achievedTitleLabel, certificatedCountLabel])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.setCustomSpacing(8, after: achievedTitleLabel)
        stack.alignment = .center
        return stack
    }()
    
    // 인정 Row
    private let acknowledgedIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "approve")
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { $0.size.equalTo(24) }
        return imageView
    }()
    
    private let acknowledgedTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "인정"
        label.font = Fonts.body2S
        label.textColor = .grey200
        label.snp.makeConstraints { $0.width.equalTo(25) }
        return label
    }()
    
    private let approvedCountLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.body2S
        label.textColor = .grey0
        return label
    }()
    
    private lazy var acknowledgedStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [acknowledgedIconImageView, acknowledgedTitleLabel, approvedCountLabel])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.setCustomSpacing(8, after: acknowledgedTitleLabel)
        stack.alignment = .center
        return stack
    }()
    
    // 노인정 Row
    private let notAcknowledgedIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "reject")
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { $0.size.equalTo(24) }
        return imageView
    }()
    
    private let notAcknowledgedTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "노인정"
        label.font = Fonts.body2S
        label.textColor = .grey200
        label.snp.makeConstraints { $0.width.equalTo(37) }
        return label
    }()
    
    private let rejectedCountLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.body2S
        label.textColor = .grey0
        return label
    }()
    
    private lazy var notAcknowledgedStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [notAcknowledgedIconImageView, notAcknowledgedTitleLabel, rejectedCountLabel])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.setCustomSpacing(8, after: notAcknowledgedTitleLabel)
        stack.alignment = .center
        return stack
    }()
    
    private lazy var summaryStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            achievedStackView,
            acknowledgedStackView,
            notAcknowledgedStackView
        ])
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureView() {
        backgroundColor = .grey800
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        addSubview(titleStackView)
        addSubview(summaryStackView)
    }
    
    override func configureConstraints() {
        titleIconImageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
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
}

extension StatsSummaryView {
    func configure(certificatedCount: Int, approvedCount: Int, rejectedCount: Int) {
        certificatedCountLabel.text = "\(certificatedCount)개"
        approvedCountLabel.text = "\(approvedCount)개"
        rejectedCountLabel.text = "\(rejectedCount)개"
    }
}
