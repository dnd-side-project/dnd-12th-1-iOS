//
//  TodoStatusButton.swift
//  dogether
//
//  Created by seungyooooong on 6/11/25.
//

import UIKit

final class TodoStatusButton: BaseButton {
    let type: TodoStatus
    
    init(type: TodoStatus) {
        self.type = type
        
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let icon = UIImageView()
    private let label = UILabel()
    
    private let stackView = UIStackView()
    
    override func configureView() {
        backgroundColor = type.backgroundColor
        layer.cornerRadius = 16
        
        icon.image = type.image?.withRenderingMode(.alwaysTemplate)
        icon.tintColor = .grey900
        
        label.text = type.text
        label.textColor = .grey900
        label.font = Fonts.body2S
        
        stackView.axis = .horizontal
        stackView.spacing = 4
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
            
            icon.snp.updateConstraints {
                $0.width.height.equalTo(16)
            }
        }
    }
}

extension TodoStatusButton {
    func update(type: TodoStatus) {
        backgroundColor = type.backgroundColor
        icon.image = type.image?.withRenderingMode(.alwaysTemplate)
        label.text = type.text
        
        stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0) }
        
        let views = icon.image == nil ? [label] : [icon, label]
        views.forEach { stackView.addArrangedSubview($0) }
        
        icon.snp.updateConstraints {
            $0.width.height.equalTo(16)
        }
    }
}
