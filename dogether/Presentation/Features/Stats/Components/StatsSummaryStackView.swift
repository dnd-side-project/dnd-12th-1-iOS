//
//  StatsSummaryStackView.swift
//  dogether
//
//  Created by seungyooooong on 11/27/25.
//

import UIKit

final class StatsSummaryStackView: BaseStackView {
    private let type: CertificationTypes
    
    init(type: CertificationTypes) {
        self.type = type
        
        super.init(frame: .zero)
    }
    required init(coder: NSCoder) { fatalError() }
        
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let countLabel = UILabel()
    
    override func configureView() {
        axis = .horizontal
        alignment = .center
        distribution = .fill
        
        imageView.image = type.iconImage
        imageView.contentMode = .scaleAspectFit
        
        titleLabel.text = type.text
        titleLabel.font = Fonts.body2S
        titleLabel.textColor = .grey200
        
        countLabel.font = Fonts.body2S
        countLabel.textColor = .grey0
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [imageView, titleLabel, countLabel].forEach { addArrangedSubview($0) }
    }
    
    override func configureConstraints() {
        imageView.snp.makeConstraints { $0.size.equalTo(24) }
        
        // FIXME: achievement에서 width가 늘어나는 이슈가 있음, 추후 삭제
        titleLabel.snp.makeConstraints { $0.width.equalTo(type.titleLabelWidth) }
        
        setCustomSpacing(4, after: imageView)
        setCustomSpacing(8, after: titleLabel)
    }
    
    // MARK: - updateView
    override func updateView(_ data: String) {
        countLabel.text = data
    }
}
