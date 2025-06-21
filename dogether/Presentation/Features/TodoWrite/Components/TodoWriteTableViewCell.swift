//
//  TodoWriteTableViewCell.swift
//  dogether
//
//  Created by seungyooooong on 3/30/25.
//

import UIKit

final class TodoWriteTableViewCell: BaseTableViewCell, ReusableProtocol {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let tableViewCell = {
        let view = UIView()
        view.backgroundColor = .grey800
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let todoLabel = {
        let label = UILabel()
        label.font = Fonts.body1S
        return label
    }()
    
    private let deleteButton = {
        let button = UIButton()
        button.setImage(.close.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .grey300
        return button
    }()
    
    override func configureView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(tableViewCell)
    }
    
    override func configureAction() { }
        
    override func configureHierarchy() {
        [todoLabel, deleteButton].forEach { tableViewCell.addSubview($0) }
    }
    
    override func configureConstraints() {
        tableViewCell.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview().inset(6)
            $0.height.equalTo(64)
        }
        
        todoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        deleteButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.height.equalTo(20)
        }
    }
}

extension TodoWriteTableViewCell {
    func setExtraInfo(todo: WriteTodoInfo, index: Int, deleteAction: @escaping (Int) -> Void) {
        todoLabel.text = todo.content
        todoLabel.textColor = todo.enabled ? .grey50 : .grey500
        deleteButton.tag = index
        deleteButton.removeTarget(nil, action: nil, for: .touchUpInside)
        deleteButton.isHidden = !todo.enabled
        if todo.enabled {
            deleteButton.addAction(
                UIAction { [weak deleteButton] _ in
                    guard let deleteButton else { return }
                    deleteAction(deleteButton.tag)
                }, for: .touchUpInside
            )
        }
    }
}
