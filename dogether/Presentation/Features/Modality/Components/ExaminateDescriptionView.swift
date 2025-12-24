//
//  ExaminateDescriptionView.swift
//  dogether
//
//  Created by seungyooooong on 12/7/25.
//

import UIKit

final class ExaminateDescriptionView: BaseView {
    private let icon = UIImageView(image: .notice)
    private let label = UILabel()
    private let stackView = UIStackView()
    
    override func configureView() {
        label.text = "검사 결과는 선택하면 수정할 수 없어요"
        label.textColor = .grey200
        label.font = Fonts.body1R
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.distribution = .fill
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [icon, label].forEach { stackView.addArrangedSubview($0) }
        
        addSubview(stackView)
    }
    
    override func configureConstraints() {
        icon.snp.makeConstraints {
            $0.size.equalTo(16)
        }
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
