//
//  GroupCreateViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/9/25.
//

import UIKit
import SnapKit

final class GroupCreateViewController: BaseViewController {
    private let viewModel = GroupCreateViewModel()
    
    private let navigationHeader = NavigationHeader(title: "그룹 만들기")
    
    private let currentStepLabel = {
        let label = UILabel()
        label.textColor = .blue300
        label.font = Fonts.body1S
        return label
    }()
    
    private let maxStepLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.font = Fonts.body1S
        return label
    }()
    
    private let stepLabelStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let stepDescriptionLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.font = Fonts.head1B
        return label
    }()
    
    private let completeButton = DogetherButton(title: "다음", status: .disabled)
    
    private func stepView(step: CreateGroupSteps) -> UIView {
        let view = UIView()
        view.isHidden = viewModel.currentStep != step
        view.tag = step.rawValue
        return view
    }
    private var stepOneView = UIView()
    private var stepTwoView = UIView()
    private var stepThreeView = UIView()
    
    private func componentTitleLabel(componentTitle: String) -> UILabel {
        let label = UILabel()
        label.text = componentTitle
        label.textColor = .grey200
        label.font = Fonts.body1B
        return label
    }
    private var groupName = UILabel()
    private var memberCount = UILabel()
    private var duration = UILabel()
    private var startAt = UILabel()
    
    // TODO: 추후 공용 컴포넌트로 빼기
    private let groupNameTextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "멋진 그룹명으로 동기부여를 해보세요 !",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.grey300]
        )
        textField.textColor = .grey0
        textField.font = Fonts.body1S
        textField.tintColor = .blue300
        textField.returnKeyType = .done
        textField.borderStyle = .none
        textField.backgroundColor = .grey800
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.clear.cgColor
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let groupNameCountLabel = {
        let label = UILabel()
        label.textColor = .grey300
        label.font = Fonts.smallS
        return label
    }()
    
    private let groupNameMaxLengthLabel = {
        let label = UILabel()
        label.textColor = .grey300
        label.font = Fonts.smallS
        return label
    }()
    
    private let groupNameCountStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private var memberCountView = UIView()
    
    private let threeDaysButton = DurationButton(duration: .threeDays)
    private let oneWeekButton = DurationButton(duration: .oneWeek)
    private let twoWeeksButton = DurationButton(duration: .twoWeeks)
    private let fourWeeksButton = DurationButton(duration: .fourWeeks)
    
    private let todayButton = StartAtButton(startAt: .today)
    private let tomorrowButton = StartAtButton(startAt: .tomorrow)
    
    private func horizontalStackView(buttons: [UIButton]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }
    private var durationRow1 = UIStackView()
    private var durationRow2 = UIStackView()
    private var startAtStack = UIStackView()
    
    private func verticalStackView(stacks: [UIStackView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: stacks)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }
    private var durationStack = UIStackView()
    
    private let dogetherGroupInfo = DogetherGroupInfo()
    
    override func viewDidAppear(_ animated: Bool) {
        groupNameTextField.becomeFirstResponder()
    }
    
    override func configureView() {
        updateDuration()
        updateStartAt()
        
        currentStepLabel.text = "\(viewModel.currentStep.rawValue)"
        maxStepLabel.text = "/\(viewModel.maxStep)"
        [currentStepLabel, maxStepLabel].forEach { stepLabelStackView.addArrangedSubview($0) }
        
        stepDescriptionLabel.text = viewModel.currentStep.description
        
        stepOneView = stepView(step: .one)
        stepTwoView = stepView(step: .two)
        stepThreeView = stepView(step: .three)
        
        groupName = componentTitleLabel(componentTitle: "그룹명")
        groupNameCountLabel.text = "\(viewModel.currentGroupName.count)"
        groupNameMaxLengthLabel.text = "/\(viewModel.groupNameMaxLength)"
        [groupNameCountLabel, groupNameMaxLengthLabel].forEach { groupNameCountStackView.addArrangedSubview($0) }
        
        memberCount = componentTitleLabel(componentTitle: "그룹 인원")
        memberCountView = CounterView(min: 2, max: 20, current: viewModel.memberCount, unit: "명") { [weak self] in
            self?.viewModel.updateMemberCount(count: $0)
        }
        
        duration = componentTitleLabel(componentTitle: "활동 기간")
        durationRow1 = horizontalStackView(buttons: [threeDaysButton, oneWeekButton])
        durationRow2 = horizontalStackView(buttons: [twoWeeksButton, fourWeeksButton])
        durationStack = verticalStackView(stacks: [durationRow1, durationRow2])
        
        startAt = componentTitleLabel(componentTitle: "시작일")
        startAtStack = horizontalStackView(buttons: [todayButton, tomorrowButton])
    }
    
    override func configureAction() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        navigationHeader.delegate = self
        
        completeButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                if viewModel.currentStep.rawValue == viewModel.maxStep {
                    tryCreateGroup()
                } else {
                    guard let nextStep = CreateGroupSteps(rawValue: viewModel.currentStep.rawValue + 1) else { return }
                    viewModel.updateStep(step: nextStep)
                    updateStep()
                }
            }, for: .touchUpInside
        )
        
        groupNameTextField.delegate = self
        groupNameTextField.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                viewModel.updateGroupName(groupName: groupNameTextField.text)
                groupNameTextField.text = viewModel.currentGroupName
                groupNameCountLabel.text = String(viewModel.currentGroupName.count)
                completeButton.setButtonStatus(status: viewModel.currentStep == .one && viewModel.currentGroupName.count > 0 ? .enabled : .disabled)
            }, for: .editingChanged
        )
        
        [threeDaysButton, oneWeekButton, twoWeeksButton, fourWeeksButton].forEach { button in
            button.addAction(
                UIAction { [weak self, weak button] _ in
                    guard let self, let button else { return }
                    updateDuration(button.duration)
                }, for: .touchUpInside
            )
        }
        
        [todayButton, tomorrowButton].forEach { button in
            button.addAction(
                UIAction { [weak self, weak button] _ in
                    guard let self, let button else { return }
                    updateStartAt(button.startAt)
                }, for: .touchUpInside
            )
        }
    }
    
    override func configureHierarchy() {
        [ navigationHeader, stepLabelStackView, stepDescriptionLabel, completeButton,
          stepOneView, stepTwoView, stepThreeView
        ].forEach { view.addSubview($0) }
        
        [groupName, groupNameTextField, groupNameCountStackView, memberCount, memberCountView].forEach { stepOneView.addSubview($0) }
        
        [duration, durationStack, startAt, startAtStack].forEach { stepTwoView.addSubview($0) }
        
        [dogetherGroupInfo].forEach { stepThreeView.addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        stepLabelStackView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom).offset(44)
            $0.left.equalToSuperview().inset(16)
            $0.height.equalTo(25)
        }
        
        stepDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(stepLabelStackView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        completeButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        // MARK: - stepOne
        stepOneView.snp.makeConstraints {
            $0.top.equalTo(stepDescriptionLabel.snp.bottom).offset(24)
            $0.bottom.equalTo(memberCountView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        groupName.snp.makeConstraints {
            $0.top.equalToSuperview()
        }
        
        groupNameTextField.snp.makeConstraints {
            $0.top.equalTo(groupName.snp.bottom).offset(8)
            $0.width.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        groupNameCountStackView.snp.makeConstraints {
            $0.centerY.equalTo(groupNameTextField)
            $0.right.equalTo(groupNameTextField).inset(16)
            $0.height.equalTo(18)
        }
        
        memberCount.snp.makeConstraints {
            $0.top.equalTo(groupNameTextField.snp.bottom).offset(20)
        }
        
        memberCountView.snp.makeConstraints {
            $0.top.equalTo(memberCount.snp.bottom).offset(8)
            $0.width.equalToSuperview()
            $0.height.equalTo(79)
        }
        
        // MARK: - stepTwo
        stepTwoView.snp.makeConstraints {
            $0.top.equalTo(stepDescriptionLabel.snp.bottom).offset(24)
            $0.bottom.equalTo(startAtStack.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        duration.snp.makeConstraints {
            $0.top.equalToSuperview()
        }
        
        durationStack.snp.makeConstraints {
            $0.top.equalTo(duration.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(108)
        }
        
        startAt.snp.makeConstraints {
            $0.top.equalTo(durationStack.snp.bottom).offset(30)
        }
        
        startAtStack.snp.makeConstraints {
            $0.top.equalTo(startAt.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(166)
        }
        
        // MARK: - stepThree
        stepThreeView.snp.makeConstraints {
            $0.top.equalTo(stepDescriptionLabel.snp.bottom).offset(34)
            $0.bottom.equalTo(dogetherGroupInfo.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(36)
        }
        
        dogetherGroupInfo.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(267)
        }
    }
}

extension GroupCreateViewController {
    private func tryCreateGroup() {
        Task {
            do {
                try await viewModel.createGroup()
                guard let joinCode = viewModel.joinCode else { return }
                await MainActor.run {
                    let completeViewController = CompleteViewController()
                    completeViewController.viewModel.groupType = .create
                    completeViewController.viewModel.joinCode = joinCode
                    completeViewController.viewModel.groupInfo = ChallengeGroupInfo(name: viewModel.currentGroupName)
                    coordinator?.setNavigationController(completeViewController)
                }
            } catch let error as NetworkError {
                ErrorHandlingManager.presentErrorView(
                    error: error,
                    presentingViewController: self,
                    coordinator: coordinator,
                    retryHandler: { [weak self] in
                        guard let self else { return }
                        tryCreateGroup()
                    }
                )
            }
        }
    }
}

// MARK: - update UI
extension GroupCreateViewController {
    private func updateStep() {
        currentStepLabel.text = "\(viewModel.currentStep.rawValue)"
        
        [stepOneView, stepTwoView, stepThreeView].forEach {
            guard let step = CreateGroupSteps(rawValue: $0.tag) else { return }
            $0.isHidden = viewModel.currentStep != step
        }
        
        stepDescriptionLabel.text = viewModel.currentStep.description
        if viewModel.currentStep == .two { view.endEditing(true) }
        if viewModel.currentStep == .three {
            completeButton.setTitle("그룹 생성")
            dogetherGroupInfo.setInfo(
                groupName: viewModel.currentGroupName,
                memberCount: viewModel.memberCount,
                duration: viewModel.currentDuration,
                startAt: viewModel.currentStartAt
            )
        }
    }
    
    private func updateDuration(_ duration: GroupChallengeDurations = .threeDays) {
        viewModel.updateDuration(duration: duration)
        
        [threeDaysButton, oneWeekButton, twoWeeksButton, fourWeeksButton].forEach {
            $0.setColorful(isColorful: viewModel.currentDuration == $0.duration)
        }
    }
    
    private func updateStartAt(_ startAt: GroupStartAts = .today) {
        viewModel.updateStartAt(startAt: startAt)
        
        [todayButton, tomorrowButton].forEach {
            $0.setColorful(isColorful: viewModel.currentStartAt == $0.startAt)
        }
    }
}

// MARK: - abount keyboard
extension GroupCreateViewController: UITextFieldDelegate {
    // MARK: - UITextFieldDelegate
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
    
    @objc private func dismissKeyboard() { view.endEditing(true) }
}
