//
//  TodoWriteViewController.swift
//  dogether
//
//  Created by seungyooooong on 3/30/25.
//

import UIKit

import RxSwift
import RxCocoa

final class TodoWriteViewController: BaseViewController {
    private let todoWritePage = TodoWritePage()
    private let viewModel = TodoWriteViewModel()
    
    override func viewDidLoad() {
        todoWritePage.delegate = self
        
        pages = [todoWritePage]
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.updateIsFirstResponder(isFirstResponder: true)
    }
    
    override func setViewDatas() {
        if let datas = datas as? TodoWriteViewDatas {
            viewModel.todoWriteViewDatas.accept(datas)
        }
        
        bind(viewModel.todoWriteViewDatas)
    }
}

// MARK: - delegate
protocol TodoWriteDelegate {
    func updateIsShowKeyboardAction(isShowKeyboard: Bool)
    func updateTodoAction(todo: String)
    func addTodoAction(todoMaxCount: Int)
    func removeTodoAction(index: Int)
    func saveTodoAction()
}

extension TodoWriteViewController: TodoWriteDelegate {
    func updateIsShowKeyboardAction(isShowKeyboard: Bool) {
        viewModel.updateIsShowKeyboard(isShowKeyboard: isShowKeyboard)
    }
    
    func updateTodoAction(todo: String) {
        viewModel.updateTodo(todo: todo)
    }
    
    func addTodoAction(todoMaxCount: Int) {
        viewModel.addTodo(todoMaxCount: todoMaxCount)
    }
    
    func removeTodoAction(index: Int) {
        viewModel.removeTodo(index: index)
    }
    
    func saveTodoAction() {
        coordinator?.showPopup(type: .alert, alertType: .saveTodo) { [weak self] _ in
            guard let self else { return }
            Task {
                try await self.viewModel.createTodos()
                await MainActor.run {
                    self.coordinator?.popViewController()
                }
            }
        }
    }
}
