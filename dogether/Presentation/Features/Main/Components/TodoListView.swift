//
//  TodoListView.swift
//  dogether
//
//  Created by seungyooooong on 5/9/25.
//

import UIKit

final class TodoListView: BaseView {
    var delegate: MainDelegate? {
        didSet {
            filterStackView.mainDelegate = delegate
            addTodoButton.addAction(
                UIAction { [weak self] _ in
                    guard let self, let currentTodoList else { return }
                    delegate?.goWriteTodoViewAction(todos: currentTodoList)
                }, for: .touchUpInside
            )
        }
    }
    
    private(set) var currentFilter: FilterTypes?
    private(set) var currentTodoList: [TodoEntity]?
    
    private let filterStackView = FilterStackView()
    
    private let todoScrollView = UIScrollView()
    private let todoListStackView = UIStackView()
    
    private let emptyListImageView = UIImageView(image: .embarrassedDosik)
    private let emptyListTitleLabel = UILabel()
    private let emptyListDescriptionLabel = UILabel()
    private let emptyListStackView = UIStackView()
    
    private let addTodoButton = AdditionalAddTodoButton()
    
    override func configureView() {
        todoScrollView.bounces = false
        todoScrollView.showsVerticalScrollIndicator = false
        
        todoListStackView.axis = .vertical
        todoListStackView.spacing = 8
        todoListStackView.distribution = .fillEqually
        
        emptyListTitleLabel.textColor = .grey200
        emptyListTitleLabel.font = Fonts.head2B
        emptyListDescriptionLabel.text = "오늘 하루 이루고 싶은 목표를 입력해보세요!"
        emptyListDescriptionLabel.textColor = .grey400
        emptyListDescriptionLabel.font = Fonts.body2R
        
        emptyListStackView.axis = .vertical
        emptyListStackView.alignment = .center
        emptyListStackView.setCustomSpacing(16, after: emptyListImageView)
        emptyListStackView.setCustomSpacing(4, after: emptyListTitleLabel)
    }
    
    override func configureAction() {
        todoScrollView.delegate = self
    }
    
    override func configureHierarchy() {
        [emptyListImageView, emptyListTitleLabel, emptyListDescriptionLabel].forEach {
            emptyListStackView.addArrangedSubview($0)
        }
        
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
            $0.width.height.equalTo(150)
            // FIXME: embarrassedDosik 이미지 교체 후 수정
//            $0.width.equalTo(129)
//            $0.height.equalTo(148)
        }
        
        emptyListTitleLabel.snp.makeConstraints {
            $0.height.equalTo(28)
        }
        
        emptyListDescriptionLabel.snp.makeConstraints {
            $0.height.equalTo(21)
        }
        
        emptyListStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: any BaseEntity) {
        if let datas = data as? SheetViewDatas {
            todoScrollView.isScrollEnabled = datas.sheetStatus == .expand
            
            if currentFilter == datas.filter && currentTodoList == datas.todoList { return }
            currentFilter = datas.filter
            currentTodoList = datas.todoList
            
            filterStackView.updateView(datas.filter)
            
            let isToday = datas.dateOffset == 0
            
            let currentTodoList = datas.todoList.filter {
                datas.filter == .all || datas.filter == FilterTypes(status: $0.status.rawValue)
            }
            todoListStackView.isHidden = currentTodoList.isEmpty
            emptyListStackView.isHidden = !currentTodoList.isEmpty
            
            todoListStackView.subviews.forEach { todoListStackView.removeArrangedSubview($0) }
            currentTodoList
                .enumerated().map {
                    let todoListItemButton = TodoListItemButton(index: $0, todo: $1, isToday: isToday)
                    todoListItemButton.delegate = delegate
                    return todoListItemButton
                }
                .forEach { todoListStackView.addArrangedSubview($0) }
            
            if datas.todoList.count < 10 && isToday {
                addTodoButton.updateView(datas)
                todoListStackView.addArrangedSubview(addTodoButton)
            }
            
            emptyListTitleLabel.text = datas.filter.emptyTitle
        }
    }
}

extension TodoListView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.updateIsScrollOnTop(isScrollOnTop: scrollView.contentOffset.y <= 0)
    }
}
