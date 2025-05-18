//
//  TodoListView.swift
//  dogether
//
//  Created by seungyooooong on 5/9/25.
//

import UIKit

final class TodoListView: BaseView {
    init() { super.init(frame: .zero) }
    required init?(coder: NSCoder) { fatalError() }
    
    var allButton = FilterButton(type: .all)
    var waitButton = FilterButton(type: .wait)
    var rejectButton = FilterButton(type: .reject)
    var approveButton = FilterButton(type: .approve)
    
    private let filterStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    var todoScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    var todoListStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let emptyListImageView = UIImageView(image: .comment)
    
    private let emptyListLabel = {
        let label = UILabel()
        label.textColor = .grey400
        label.font = Fonts.head2B
        return label
    }()
    
    private let emptyListStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        return stackView
    }()
    
    override func configureView() {
        [allButton, waitButton, rejectButton, approveButton].forEach { filterStackView.addArrangedSubview($0) }
        [emptyListImageView, emptyListLabel].forEach { emptyListStackView.addArrangedSubview($0) }
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [todoScrollView, emptyListStackView, filterStackView].forEach { addSubview($0) }
        [todoListStackView].forEach { todoScrollView.addSubview($0) }
    }
    
    override func configureConstraints() {
        filterStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.left.equalToSuperview().offset(16)
        }
        
        todoScrollView.snp.makeConstraints {
            $0.top.equalTo(filterStackView.snp.bottom).offset(20)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        todoListStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview() // MARK: item 대신 stackView에서 너비 지정
        }
        
        emptyListImageView.snp.makeConstraints {
            $0.width.equalTo(74)
            $0.height.equalTo(54)
        }
        
        emptyListLabel.snp.makeConstraints {
            $0.height.equalTo(28)
        }
        
        emptyListStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}

extension TodoListView {
    func updateList(todoList: [TodoInfo], filter: FilterTypes, isToday: Bool) {
        allButton.setIsColorful(filter == .all)
        waitButton.setIsColorful(filter == .wait)
        rejectButton.setIsColorful(filter == .reject)
        approveButton.setIsColorful(filter == .approve)
        
        todoListStackView.isHidden = todoList.isEmpty
        emptyListStackView.isHidden = !todoList.isEmpty
        
        todoListStackView.subviews.forEach { todoListStackView.removeArrangedSubview($0) }
        todoList
            .map { TodoListItemButton(todo: $0, isToday: isToday) }
            .forEach { todoListStackView.addArrangedSubview($0) }
        
        emptyListLabel.text = filter.emptyDescription
    }
}
