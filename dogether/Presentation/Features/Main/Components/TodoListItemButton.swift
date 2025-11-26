//
//  TodoListItemButton.swift
//  dogether
//
//  Created by seungyooooong on 2/14/25.
//

import UIKit
import SnapKit

final class TodoListItemButton: BaseButton {
    var delegate: MainDelegate? {
        didSet {
            addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    if isUncertified {
                        if isToday {
                            delegate?.goCertificateViewAction(todo: todo)
                        } else { return }
                    } else {
                        delegate?.goCertificationViewAction(index: index)
                    }
                }, for: .touchUpInside
            )
        }
    }
    
    private(set) var index: Int
    private(set) var todo: TodoEntity
    private(set) var isToday: Bool
    private(set) var isUncertified: Bool
    
    init(index: Int, todo: TodoEntity, isToday: Bool) {
        self.index = index
        self.todo = todo
        self.isToday = isToday
        self.isUncertified = todo.status == .waitCertification
        
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let todoImageView = UIImageView()
    
    private let contentLabel = UILabel()
    
    private let certificationLabel = UILabel()
    
    private let checkImageView = UIImageView(image: .chevronRight.withRenderingMode(.alwaysTemplate))
    
    override func configureView() {
        backgroundColor = .grey700
        layer.cornerRadius = 8
        
        todoImageView.image = todo.status.image
        
        contentLabel.text = todo.content
        contentLabel.textColor = isUncertified ? isToday ? .grey0 : .grey400 : .grey300
        contentLabel.font = Fonts.body1S
        contentLabel.isUserInteractionEnabled = false
        
        certificationLabel.text = "인증하기"
        certificationLabel.textColor = isToday ? .grey900 : .grey400
        certificationLabel.textAlignment = .center
        certificationLabel.font = Fonts.body2S
        certificationLabel.layer.cornerRadius = 8
        certificationLabel.clipsToBounds = true
        certificationLabel.isUserInteractionEnabled = false
        certificationLabel.backgroundColor = isToday ? .blue300 : .grey500
        
        checkImageView.tintColor = .grey200
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
        
        if todo.status != .waitCertification {
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
                $0.width.height.equalTo(24)
            }
        }
    }
}
