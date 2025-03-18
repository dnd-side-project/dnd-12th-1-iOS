//
//  GroupJoinTest.swift
//  dogether
//
//  Created by 박지은 on 3/12/25.
//

import UIKit
import SnapKit

class GroupJoinViewController: BaseViewController {
    
    private let dogetherHeader = NavigationHeader(title: "그룹 가입하기")
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "초대번호 입력"
        label.font = Fonts.emphasis2B
        label.textColor = .grey0
        return label
    }()
    
    private let subtitleLabel = {
        let label = UILabel()
        label.text = "초대받은 링크에서 초대코드를 확인할 수 있어요"
        label.font = Fonts.body1R
        label.textColor = .grey200
        label.isHidden = false
        return label
    }()
    
    private let errorLabel = {
        let label = UILabel()
        label.text = "해당 번호는 존재하지 않아요!"
        label.textColor = .dogetherRed
        label.isHidden = true
        return label
    }()
    
    private let textField = UITextField()
    
    let attributes: [NSAttributedString.Key: Any] = [
        .kern: 37.0, // 자간 값 (원하는 만큼 조정 가능)
        .foregroundColor: UIColor.white,
        .font: UIFont.systemFont(ofSize: 16)
    ]
    
    private var digitViews: [UILabel] = []
    private let numberOfDigits = 6
    let stackView = UIStackView()
    
    private lazy var joinButton = {
        let button = UIButton()
        button.setTitle("가입하기", for: .normal)
        button.titleLabel?.font = Fonts.body1B
        button.setTitleColor(.grey400, for: .normal)
        button.backgroundColor = .grey500
        button.layer.cornerRadius = 12
        button.isEnabled = false
        button.addTarget(self, action: #selector(joinButtonClicked), for: .touchUpInside)
        return button
    }()
    
    override func configureHierarchy() {
        [dogetherHeader, titleLabel, subtitleLabel, errorLabel,stackView, textField, joinButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        
        dogetherHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(28)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(100)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        errorLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        textField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(80)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(textField.snp.top)
            $0.width.equalTo(308)
            $0.height.equalTo(60)
        }
        
        joinButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
    }
    
    override func configureView() {
        textField.backgroundColor = .clear
        textField.defaultTextAttributes = attributes
        textField.delegate = self
        textField.keyboardType = .asciiCapable
        textField.becomeFirstResponder()
        textField.clipsToBounds = false
        textField.adjustsFontSizeToFitWidth = false
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 58, height: 0))
        textField.leftViewMode = .always
        
        textField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        stackView.backgroundColor = .clear
        
        for _ in 0..<numberOfDigits {
            let digitLabel = UILabel()
            digitLabel.backgroundColor = .grey700
            digitLabel.layer.cornerRadius = 15
            digitLabel.numberOfLines = 0
            digitLabel.layer.masksToBounds = true
            
            stackView.addArrangedSubview(digitLabel)
            digitViews.append(digitLabel)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTapGesture()
        setupKeyboardHandling()
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        view.addGestureRecognizer(tapGesture)
        stackView.addGestureRecognizer(tapGesture2)
    }
    
    @objc private func textDidChange(_ textField: UITextField) {
        
        guard let text = textField.text, !text.isEmpty else { return }
        
        // 입력중인 텍스트필드 border 색상 변경
        setTextFieldBorderColor()
        
        textField.textColor = .grey0
        textField.font = Fonts.head1B
        
        joinButton.backgroundColor = joinButton.isEnabled ? .blue300 : .grey100
        joinButton.setTitleColor(joinButton.isEnabled ? .grey800 : .grey400, for: .normal)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func handleTap() {
        textField.becomeFirstResponder()
    }
    
    @objc private func joinButtonClicked() {
        
        Task {
            do {
                let request = JoinGroupRequest(joinCode: textField.text ?? "")
                let response: JoinGroupResponse = try await NetworkManager.shared.request(GroupsRouter.joinGroup(joinGroupRequest: request))
                
                let completeViewController = CompleteViewController(type: .join)
                completeViewController.viewModel.joinGroupResponse = response
                NavigationManager.shared.setNavigationController(completeViewController)
                
            } catch {
                print("❌ 가입 실패: \(error)")
                
                subtitleLabel.isHidden = true
                errorLabel.isHidden = false
                
                // 텍스트필드 초기화
                textField.text = ""
                textField.becomeFirstResponder()
                
                joinButton.isEnabled = false
                joinButton.backgroundColor = .grey500
            }
        }
    }
}

extension GroupJoinViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        // 현재 텍스트
        let currentText = textField.text ?? ""
        // 새 텍스트 예상 길이 계산
        let newLength = currentText.count + string.count - range.length
        // 최대 6자 제한
        return newLength <= 6
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text, text.count == 6 {
            textField.resignFirstResponder() // 키보드 내리기
            joinButton.isEnabled = true // 버튼 활성화
        } else {
            joinButton.isEnabled = false // 버튼 비활성화
        }
    }
    
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func setTextFieldBorderColor() {
        for digitLabel in digitViews {
            if textField.isFirstResponder {
                digitLabel.layer.borderColor = UIColor.blue300.cgColor
                digitLabel.layer.borderWidth = 1.5
            } else {
                digitLabel.layer.borderColor = UIColor.clear.cgColor
                digitLabel.layer.borderWidth = 0
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setTextFieldBorderColor()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setTextFieldBorderColor()
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        joinButton.snp.updateConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(keyboardFrame.cgRectValue.height - 16)
        }
        self.view.layoutIfNeeded()
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        joinButton.snp.updateConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        self.view.layoutIfNeeded()
    }
}
