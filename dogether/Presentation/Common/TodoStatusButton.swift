//
//  TodoStatusButton.swift
//  dogether
//
//  Created by seungyooooong on 6/11/25.
//

import UIKit

final class TodoStatusButton: BaseButton {
    private let icon = UIImageView()
    private let label = UILabel()
    private let stackView = UIStackView()
    
    override func configureView() {
        layer.cornerRadius = 16
        
        icon.tintColor = .grey900
        
        label.textColor = .grey800
        label.font = Fonts.body2S
        
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.isUserInteractionEnabled = false
        
        let views = icon.image == nil ? [label] : [icon, label]
        views.forEach { stackView.addArrangedSubview($0) }
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [stackView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        stackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(6)
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.center.equalToSuperview()
        }
        
        icon.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: any BaseEntity) {
        if let datas = data as? TodoStatus {
            backgroundColor = datas.backgroundColor
            icon.image = datas.image?.withRenderingMode(.alwaysTemplate)
            label.text = datas.text
            
            stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0) }
            
            let views = icon.image == nil ? [label] : [icon, label]
            views.forEach { stackView.addArrangedSubview($0) }
        }
    }
}
