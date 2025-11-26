//
//  AdditionalAddTodoButton.swift
//  dogether
//
//  Created by seungyooooong on 9/28/25.
//

import UIKit

final class AdditionalAddTodoButton: BaseButton {
    private let stackView = UIStackView()
    private let iconImageView = UIImageView(image: .plusCircle)
    private let label = UILabel()
    
    private(set) var currentCount: Int?
    
    override func configureView() {
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .grey200
        
        label.font = Fonts.body1S
        label.textColor = .grey200
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.isUserInteractionEnabled = false
        [iconImageView, label].forEach { stackView.addArrangedSubview($0) }
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        addSubview(stackView)
    }
    
    override func configureConstraints() {
        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    override func updateView(_ data: any BaseEntity) {
        if let datas = data as? SheetViewDatas {
            if currentCount == datas.todoList.count { return }
            currentCount = datas.todoList.count
            
            label.text = "투두 추가하기 (\(datas.todoList.count)/10)"
        }
    }
}
