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
    
    private var icon = UIImageView()
    
    private var label = UILabel()
    
    private let stackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.isUserInteractionEnabled = false
        return stackView
    }()
    
    override func configureView() {
        backgroundColor = type.backgroundColor
        layer.cornerRadius = 16
        
        icon.image = type.image?.withRenderingMode(.alwaysTemplate)
        icon.tintColor = .grey900
        
        label.text = type.text
        label.textColor = .grey900
        label.font = Fonts.body2S
        
        let views = icon.image == nil ? [label] : [icon, label]
        views.forEach { stackView.addArrangedSubview($0) }
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [stackView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        self.snp.makeConstraints {
            $0.width.equalTo(type.width)
        }
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        icon.snp.makeConstraints {
            $0.width.height.equalTo(type == .waitExamination ? 18 : type == .reject ? 22 : 24)    // MARK: 임의로 사이즈 조정
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
        
        self.snp.updateConstraints {
            $0.width.equalTo(type.width)
        }
        
        icon.snp.updateConstraints {
            $0.width.height.equalTo(type == .waitExamination ? 18 : type == .reject ? 22 : 24)
        }
    }
}
