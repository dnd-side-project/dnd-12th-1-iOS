//
//  TodoWriteViewController.swift
//  dogether
//
//  Created by seungyooooong on 3/30/25.
//

import UIKit

final class TodoWriteViewController: BaseViewController {
    var viewModel = TodoWriteViewModel()
    
    private let navigationHeader = NavigationHeader(title: "투두 작성")
    
    private let dateLabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(
            string: DateFormatterManager.formattedDate(format: .MdE),
            attributes: Fonts.getAttributes(for: Fonts.body1S, textAlignment: .left)
        )
        label.textColor = .grey400
        return label
    }()
    
    private let todoLimitLabel = {
       let label = UILabel()
        label.textColor = .grey0
        return label
    }()
    
    private let todoTextField = {
        let textField = UITextField()
        textField.font = Fonts.body1S
        textField.tintColor = .blue300
        textField.textColor = .grey0
        textField.returnKeyType = .done
        textField.borderStyle = .none
        textField.backgroundColor = .grey800
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.blue300.cgColor
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: textField.frame.height))
        textField.rightView = rightPaddingView
        textField.rightViewMode = .always
        
        return textField
    }()
    
    private let todoLimitTextCount = {
        let label = UILabel()
        label.textColor = .grey500
        label.font = Fonts.smallS
        return label
    }()
    
    private let addButton = {
        let button = UIButton()
        button.backgroundColor = .grey600
        button.layer.cornerRadius = 8
        button.tintColor = .grey400
        let imageView = UIImageView()
        imageView.image = .plus.withRenderingMode(.alwaysTemplate)
        imageView.isUserInteractionEnabled = false
        
        button.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        return button
    }()
    
    private let emptyListView = {
        let imageView = UIImageView(image: .embarrassedDosik)
        imageView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.attributedText = NSAttributedString(
            string: "아직 작성된 투두가 없어요",
            attributes: Fonts.getAttributes(for: Fonts.head2B, textAlignment: .center)
        )
        titleLabel.textColor = .grey400
        
        let subTitleLabel = UILabel()
        subTitleLabel.attributedText = NSAttributedString(
            string: "오늘 하루 이루고 싶은 목표를 입력해보세요!",
            attributes: Fonts.getAttributes(for: Fonts.body2R, textAlignment: .center)
        )
        subTitleLabel.textColor = .grey400
        
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, subTitleLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        
        stackView.setCustomSpacing(17, after: imageView)
        stackView.setCustomSpacing(0, after: titleLabel)
        
        imageView.snp.makeConstraints {
            $0.width.equalTo(129)
            $0.height.equalTo(148)
        }
        
        return stackView
    }()
    
    private let todoTableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private let saveButton = DogetherButton(title: "투두 저장", status: .disabled)

    override func viewDidAppear(_ animated: Bool) {
        todoTextField.becomeFirstResponder()
    }
    
    override func configureView() {
        updateView()
    }
    
    override func configureAction() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        navigationHeader.delegate = self
        
        todoTextField.delegate = self
        todoTextField.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                viewModel.updateTodo(todo: todoTextField.text)
                updateTextField()
                updateAddButtonStatus()
            }, for: .editingChanged
        )
        
        addButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                if viewModel.addTodo() {
                    todoTableView.reloadData()
                    dismissKeyboard()
                    viewModel.updateTodo(todo: "")
                    updateTextField()
                    updateView()
                    updateAddButtonStatus()
                }
            }, for: .touchUpInside
        )
        
        saveButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                self.coordinator?.showPopup(self, type: .alert, alertType: .saveTodo) { [weak self] _ in
                    guard let self else { return }
                    trySaveTodo()
                }
            }, for: .touchUpInside
        )

        todoTableView.delegate = self
        todoTableView.dataSource = self
        todoTableView.register(TodoWriteTableViewCell.self, forCellReuseIdentifier: TodoWriteTableViewCell.identifier)
    }
    
    override func configureHierarchy() {
        [ navigationHeader, dateLabel, todoLimitLabel,
          todoTextField, todoLimitTextCount, addButton,
          emptyListView, todoTableView, saveButton
        ].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        todoLimitLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        todoTextField.snp.makeConstraints {
            $0.top.equalTo(todoLimitLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(72)
            $0.height.equalTo(50)
        }
        
        todoLimitTextCount.snp.makeConstraints {
            $0.centerY.equalTo(todoTextField)
            $0.trailing.equalTo(todoTextField.snp.trailing).inset(8)
        }
        
        addButton.snp.makeConstraints {
            $0.centerY.equalTo(todoTextField)
            $0.leading.equalTo(todoTextField.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.height.equalTo(48)
        }
        
        emptyListView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(todoTextField.snp.bottom).offset(101)
        }
        
        todoTableView.snp.makeConstraints {
            $0.top.equalTo(todoTextField.snp.bottom).offset(22)
            $0.bottom.equalTo(saveButton.snp.top).offset(-10)
            $0.left.right.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}

extension TodoWriteViewController {
    private func updateView() {
        updateTextField()
        updateTodoLimitLabel()
        emptyListView.isHidden = !viewModel.todos.isEmpty
        todoTableView.isHidden = viewModel.todos.isEmpty
        todoTableView.reloadData()
        
        saveButton.setButtonStatus(status: viewModel.todos.isEmpty ? .disabled : .enabled) // FIXME: 새로 작성한 투두 없을땐 disable되게 수정필요 (기존에 작성된 투두가 있을 경우 항상 enable상태임)
    }
    
    private func updateTextField() {
        todoTextField.text = viewModel.todo
        let canAddTodo = viewModel.todos.count < viewModel.maximumTodoCount
        todoTextField.isEnabled = canAddTodo
        todoTextField.attributedPlaceholder = NSAttributedString(
            string: canAddTodo ? "예) 30분 걷기, 책 20페이지 읽기" : "모든 투두를 작성했어요!",
            attributes: [.foregroundColor: canAddTodo ? UIColor.grey300 : UIColor.grey400]
        )
        todoTextField.backgroundColor = canAddTodo ? .grey800 : .grey500
        todoLimitTextCount.isHidden = !canAddTodo

        todoLimitTextCount.attributedText = makeAttributedText(
            current: "\(viewModel.todo.count)",
            maximum: "/\(viewModel.todoMaxLength)",
            currentColor: .blue300,
            maximumColor: .grey500
        )
    }
    
    private func updateTodoLimitLabel() {
        let current = "\(viewModel.todos.count)"
        let maximum = "/\(viewModel.maximumTodoCount)"
        
        todoLimitLabel.attributedText = makeAttributedText(
            prefix: "추가 가능 투두 ",
            current: current,
            maximum: maximum,
            currentColor: .blue300,
            maximumColor: .grey600,
            baseAttributes: Fonts.getAttributes(for: Fonts.head1B, textAlignment: .left)
        )
    }
    
    private func makeAttributedText(
        prefix: String = "",
        current: String,
        maximum: String,
        currentColor: UIColor,
        maximumColor: UIColor,
        baseAttributes: [NSAttributedString.Key: Any]? = nil
    ) -> NSAttributedString {
        let fullText = "\(prefix)\(current)\(maximum)"
        let attributedText = NSMutableAttributedString(string: fullText, attributes: baseAttributes)
        
        if let range = fullText.range(of: current) {
            let nsRange = NSRange(range, in: fullText)
            attributedText.addAttribute(.foregroundColor, value: currentColor, range: nsRange)
        }
        
        if let range = fullText.range(of: maximum) {
            let nsRange = NSRange(range, in: fullText)
            attributedText.addAttribute(.foregroundColor, value: maximumColor, range: nsRange)
        }
        
        return attributedText
    }
    
    private func updateAddButtonStatus() {
        let trimmed = todoTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        addButton.isEnabled = !trimmed.isEmpty
        addButton.backgroundColor = trimmed.isEmpty ? .grey600 : .blue300
        addButton.tintColor = trimmed.isEmpty ? .grey400 : .grey900
    }
}

// MARK: - aboout tableView
extension TodoWriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TodoWriteTableViewCell.identifier,
            for: indexPath
        ) as? TodoWriteTableViewCell else { return UITableViewCell() }
        
        cell.setExtraInfo(todo: viewModel.todos[indexPath.row], index: indexPath.row) { [weak self] index in
            guard let self else { return }
            viewModel.removeTodo(index)
            todoTableView.reloadData()
            updateView()
        }
        
        return cell
    }
}

// MARK: - abount keyboard (UITextFieldDelegate)
extension TodoWriteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard addButton.isEnabled else {
            return false
        }
        if viewModel.addTodo() {
            todoTableView.reloadData()
            viewModel.updateTodo(todo: "")
            updateTextField()
            updateView()
            updateAddButtonStatus()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        todoTextField.layer.borderWidth = 1.5
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        todoTextField.layer.borderWidth = 0
    }
    
    @objc private func dismissKeyboard() { view.endEditing(true) }
}

extension TodoWriteViewController {
    private func trySaveTodo() {
        Task {
            do {
                try await self.viewModel.createTodos()
                await MainActor.run {
                    self.coordinator?.popViewController()
                }
            } catch let error as NetworkError {
                ErrorHandlingManager.presentErrorView(
                    error: error,
                    presentingViewController: self,
                    coordinator: self.coordinator,
                    retryHandler: { [weak self] in
                        guard let self else { return }
                        trySaveTodo()
                    }
                )
            }
        }
    }
}
