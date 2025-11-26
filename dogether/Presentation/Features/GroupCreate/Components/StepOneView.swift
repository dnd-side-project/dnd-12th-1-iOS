//
//  StepOneView.swift
//  dogether
//
//  Created by seungyooooong on 11/10/25.
//

import UIKit

final class StepOneView: BaseView {
    var delegate: GroupCreateDelegate? {
        didSet {
            groupNameTextField.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    let groupName = String((groupNameTextField.text ?? "").prefix(groupNameMaxLength))
                    groupNameTextField.text = groupName
                    delegate?.updateGroupNameAction(groupName: groupName)
                }, for: .editingChanged
            )
            
            memberCountView.delegate = delegate
        }
    }
    
    private let groupNameTitleLabel = UILabel()
    private let groupNameTextField = UITextField()
    private let groupNameCountLabel = UILabel()
    private let groupNameMaxLengthLabel = UILabel()
    private let groupNameCountStackView = UIStackView()
    
    private let memberCountTitleLabel = UILabel()
    private let memberCountView = CounterView()
    
    private let groupNameMaxLength: Int = 10
    
    private var currentGroupName: String?
    private var currentIsFirstResponder: Bool?
    
    override func configureView() {
        groupNameTitleLabel.text = "그룹명"
        groupNameTitleLabel.textColor = .grey200
        groupNameTitleLabel.font = Fonts.body1B
        
        groupNameTextField.attributedPlaceholder = NSAttributedString(
            string: "멋진 그룹명으로 동기부여를 해보세요 !",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.grey300]
        )
        groupNameTextField.textColor = .grey0
        groupNameTextField.font = Fonts.body1S
        groupNameTextField.tintColor = .blue300
        groupNameTextField.returnKeyType = .done
        groupNameTextField.borderStyle = .none
        groupNameTextField.backgroundColor = .grey800
        groupNameTextField.layer.cornerRadius = 12
        groupNameTextField.layer.borderWidth = 1
        groupNameTextField.layer.borderColor = UIColor.clear.cgColor
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: groupNameTextField.frame.height))
        groupNameTextField.leftView = leftPaddingView
        groupNameTextField.leftViewMode = .always
        
        groupNameCountLabel.textColor = .grey300
        groupNameCountLabel.font = Fonts.smallS
        
        groupNameMaxLengthLabel.text = "/\(groupNameMaxLength)"
        groupNameMaxLengthLabel.textColor = .grey300
        groupNameMaxLengthLabel.font = Fonts.smallS
        
        groupNameCountStackView.axis = .horizontal
        [groupNameCountLabel, groupNameMaxLengthLabel].forEach { groupNameCountStackView.addArrangedSubview($0) }
        
        memberCountTitleLabel.text = "그룹 인원"
        memberCountTitleLabel.textColor = .grey200
        memberCountTitleLabel.font = Fonts.body1B
    }
    
    override func configureAction() {
        groupNameTextField.delegate = self
    }
    
    override func configureHierarchy() {
        [ groupNameTitleLabel, groupNameTextField, groupNameCountStackView,
          memberCountTitleLabel, memberCountView
        ].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        groupNameTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
        }

        groupNameTextField.snp.makeConstraints {
            $0.top.equalTo(groupNameTitleLabel.snp.bottom).offset(8)
            $0.width.equalToSuperview()
            $0.height.equalTo(50)
        }

        groupNameCountStackView.snp.makeConstraints {
            $0.centerY.equalTo(groupNameTextField)
            $0.right.equalTo(groupNameTextField).inset(16)
            $0.height.equalTo(18)
        }

        memberCountTitleLabel.snp.makeConstraints {
            $0.top.equalTo(groupNameTextField.snp.bottom).offset(20)
        }

        memberCountView.snp.makeConstraints {
            $0.top.equalTo(memberCountTitleLabel.snp.bottom).offset(8)
            $0.width.equalToSuperview()
            $0.height.equalTo(79)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? GroupCreateViewDatas {
            if currentIsFirstResponder != datas.isFirstResponder {
                currentIsFirstResponder = datas.isFirstResponder
                
                if datas.isFirstResponder { groupNameTextField.becomeFirstResponder() }
            }
            
            if currentGroupName != datas.groupName {
                currentGroupName = datas.groupName
                
                groupNameTextField.text = datas.groupName
                groupNameCountLabel.text = "\(datas.groupName.count)"
            }
            
            memberCountView.updateView(datas)
        }
    }
}

// MARK: - about keyboard (UITextFieldDelegate)
extension StepOneView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        groupNameTextField.layer.borderColor = UIColor.blue300.cgColor
        groupNameCountLabel.textColor = .blue300
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        groupNameTextField.layer.borderColor = UIColor.clear.cgColor
        groupNameCountLabel.textColor = .grey300
    }
    
    @objc private func dismissKeyboard() { endEditing(true) }
}
