//
//  TodoListItemButton.swift
//  dogether
//
//  Created by seungyooooong on 2/14/25.
//

import Foundation
import UIKit
import SnapKit

final class TodoListItemButton: UIButton {
    private(set) var todo: TodoInfo
    private(set) var action: (TodoInfo) async -> Void
    
    init(todo: TodoInfo, action: @escaping (TodoInfo) -> Void) {
        self.todo = todo
        self.action = action
        super.init(frame: .zero)
        
        setUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private let todoImageView = UIImageView()
    
    private let contentLabel = {
        let label = UILabel()
        label.font = Fonts.body1S
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private let buttonLabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Fonts.body2S
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private func updateUI() {
        guard let status = TodoStatus(rawValue: todo.status) else { return }
        
        todoImageView.image = status.image
        
        if status == .waitCertificattion {
            contentLabel.text = todo.content
        } else {
            let attributes: [NSAttributedString.Key: Any] = [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .strikethroughColor: status.contentColor
            ]
            contentLabel.attributedText = NSAttributedString(string: todo.content, attributes: attributes)
        }
        
        contentLabel.textColor = status.contentColor
        buttonLabel.text = status.buttonText
        buttonLabel.textColor = status.buttonTextColor
        buttonLabel.backgroundColor = status.buttonColor
    }
    
    private func setUI() {
        updateUI()
        
        backgroundColor = .grey700
        layer.cornerRadius = 8
        addTarget(self, action: #selector(didTapTodoItem), for: .touchUpInside)
        
        [todoImageView, contentLabel, buttonLabel].forEach { addSubview($0) }
        
        self.snp.makeConstraints {
            $0.height.equalTo(64)
        }
        
        if todo.status != TodoStatus.waitCertificattion.rawValue {
            let imageSize = todo.status == TodoStatus.waitExamination.rawValue ? 22 : todo.status == TodoStatus.reject.rawValue ? 26 : 28 // MARK: 임의로 사이즈 조정
            todoImageView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview().offset(16)
                $0.width.height.equalTo(imageSize)
            }
        }
        
        contentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(
                todo.status == TodoStatus.waitCertificattion.rawValue ? self : todoImageView.snp.right
            ).offset(
                todo.status == TodoStatus.waitCertificattion.rawValue ? 16 : 8
            )
        }
        
        buttonLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-16)
            $0.width.equalTo(72)
            $0.height.equalTo(28)
        }
    }
    
    func updateTodoStatus(_ status: TodoStatus) {
        self.todo.status = status.rawValue
        
        updateUI()
    }
    
    @objc private func didTapTodoItem() {
        Task { @MainActor in
            await action(self.todo)
        }
    }
}
