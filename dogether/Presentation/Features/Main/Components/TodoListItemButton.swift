//
//  TodoListItemButton.swift
//  dogether
//
//  Created by seungyooooong on 2/14/25.
//

import UIKit
import SnapKit

final class TodoListItemButton: BaseButton {
    private(set) var todo: TodoInfo
    private(set) var isToday: Bool
    private(set) var isUncertified: Bool
    
    init(todo: TodoInfo, isToday: Bool) {
        self.todo = todo
        self.isToday = isToday
        self.isUncertified = todo.status == TodoStatus.waitCertification.rawValue
        
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let todoImageView = UIImageView()
    
    private let contentLabel = {
        let label = UILabel()
        label.font = Fonts.body1S
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private let certificationLabel = {
        let label = UILabel()
        label.text = "인증하기"
        label.textAlignment = .center
        label.font = Fonts.body2S
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private let checkImageView = {
        let imageView = UIImageView()
        imageView.image = .chevronRight.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .grey200
        return imageView
    }()
    
    override func configureView() {
        backgroundColor = .grey700
        layer.cornerRadius = 8
        
        todoImageView.image = TodoStatus(rawValue: todo.status)?.image
        
        contentLabel.text = todo.content
        contentLabel.textColor = isUncertified ? isToday ? .grey50 : .grey400 : .grey300
        
        certificationLabel.textColor = isToday ? .grey900 : .grey400
        certificationLabel.backgroundColor = isToday ? .blue300 : .grey500
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        let rightView = isUncertified ? certificationLabel : checkImageView
        [todoImageView, contentLabel, rightView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        self.snp.makeConstraints {
            $0.height.equalTo(64)
        }
        
        if todo.status != TodoStatus.waitCertification.rawValue {
            todoImageView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview().offset(16)
                $0.width.height.equalTo(24)
            }
        }
        
        contentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(isUncertified ? self : todoImageView.snp.right).offset(isUncertified ? 16 : 8)
            $0.right.equalTo(isUncertified ? certificationLabel.snp.left : checkImageView.snp.left)
        }
        
        if isUncertified {
            certificationLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.right.equalToSuperview().offset(-16)
                $0.width.equalTo(72)
                $0.height.equalTo(28)
            }
        } else {
            checkImageView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.right.equalToSuperview().offset(-16)
                $0.width.height.equalTo(20)
            }
        }
    }
}
