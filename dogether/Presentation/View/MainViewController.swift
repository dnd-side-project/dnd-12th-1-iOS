//
//  MainViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/13/25.
//

import Foundation
import UIKit
import SnapKit

final class MainViewController: BaseViewController {
    private var viewModel = MainViewModel()
    private var dogetherPanGesture: UIPanGestureRecognizer!
    private var dogetherSheetTopConstraint: Constraint?
    
    private let dogetherHeader = DogetherHeader()
    
    private func groupInfoView(groupInfo: GroupInfo) -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = true
        
        let nameLabel = UILabel()
        nameLabel.text = groupInfo.name
        nameLabel.textColor = .blue300
        nameLabel.font = Fonts.emphasis2B
        
        func descriptionLabel(text: String) -> UILabel {
            let label = UILabel()
            label.attributedText = NSAttributedString(
                string: text,
                attributes: Fonts.getAttributes(for: Fonts.body2S, textAlignment: .left)
            )
            label.textColor = .grey300
            return label
        }
        
        func infoLabel(text: String) -> UILabel {
            let label = UILabel()
            label.attributedText = NSAttributedString(
                string: text,
                attributes: Fonts.getAttributes(for: Fonts.body1S, textAlignment: .left)
            )
            label.textColor = .grey0
            return label
        }
        
        let durationDescriptionLabel = descriptionLabel(text: "총 기간")
        let durationInfoLabel = infoLabel(text: "\(groupInfo.duration)일")
        
        let joinCodeDescriptionLabel = descriptionLabel(text: "초대코드")
        let joinCodeInfoLabel = infoLabel(text: groupInfo.joinCode)
        
        let endDateDescriptionLabel = descriptionLabel(text: "종료일")
        let endDateInfoLabel = infoLabel(
            text: "\(groupInfo.endAt)(D-\(groupInfo.remainingDays))"
        )
        
        func infoStackView(labels: [UILabel]) -> UIStackView {
            let stackView = UIStackView(arrangedSubviews: labels)
            stackView.axis = .vertical
            return stackView
        }
        
        let durationStackView = infoStackView(labels: [durationDescriptionLabel, durationInfoLabel])
        let joinCodeStackView = infoStackView(labels: [joinCodeDescriptionLabel, joinCodeInfoLabel])
        let endDateStackView = infoStackView(labels: [endDateDescriptionLabel, endDateInfoLabel])
        
        let groupInfoStackView = UIStackView(arrangedSubviews: [durationStackView, joinCodeStackView, endDateStackView])
        groupInfoStackView.axis = .horizontal
        groupInfoStackView.spacing = 28
        
        [nameLabel, groupInfoStackView].forEach { view.addSubview($0) }
        
        nameLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview()
            $0.height.equalTo(36)
        }
        
        groupInfoStackView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(16)
            $0.left.equalToSuperview()
        }
        
        return view
    }
    private var groupInfoView = UIView()
    
    private let rankingButton = {
        let button = UIButton()
        button.backgroundColor = .grey700
        button.layer.cornerRadius = 8
        
        let imageView = UIImageView()
        imageView.image = .chart
        imageView.isUserInteractionEnabled = false
        
        let label = UILabel()
        label.text = "순위 보러가기 !"
        label.textColor = .grey100
        label.font = Fonts.body1S
        label.isUserInteractionEnabled = false
        
        let chevronImageView = UIImageView()
        chevronImageView.image = .chevronRight.withRenderingMode(.alwaysTemplate)
        chevronImageView.tintColor = .grey100
        chevronImageView.isUserInteractionEnabled = false
        
        [imageView, label, chevronImageView].forEach { button.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.width.height.equalTo(24)
        }
        
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(imageView.snp.right).offset(8)
            $0.height.equalTo(25)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-16)
            $0.width.height.equalTo(22)
        }
        
        return button
    }()
    private let dogetherSheet = {
        let view = UIView()
        view.backgroundColor = .grey800
        view.layer.cornerRadius = 32
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    private let dogetherSheetHeaderLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.font = Fonts.head2B
        return label
    }()
    private func dogetherContentView(status: MainViewStatus) -> UIView {
        let view = UIView()
        view.tag = status.rawValue
        view.isHidden = viewModel.mainViewStatus != status
        return view
    }
    private let dogetherScrollView = UIScrollView()
    private var beforeStartView = UIView()
    private var emptyListView = UIView()
    private var todoListView = UIView()
    private let timerView = {
        let view = UIView()
        view.backgroundColor = .grey700
        view.layer.cornerRadius = 142 / 2
        return view
    }()
    private let timerInfoView = UIView()
    private var timeProgress = UIView()
    private let timeProgressLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.blue300.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 6
        return shapeLayer
    }()
    private let timerImageView = {
        let imageView = UIImageView()
        imageView.image = .wait.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .blue300
        return imageView
    }()
    private let timerLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.font = Fonts.head1B
        return label
    }()
    private let beforeStartTitleLabel = {
        let label = UILabel()
        label.text = "내일부터 투두를 시작할 수 있어요!"
        label.textColor = .grey0
        label.font = Fonts.head2B
        return label
    }()
    private let beforeStartSubTitleLabel = {
        let label = UILabel()
        label.text = "오늘은 계획을 세우고, 내일부터 실천해보세요!"
        label.textColor = .grey300
        label.font = Fonts.body2R
        return label
    }()
    private let todoImageView = {
        let imageView = UIImageView()
        imageView.image = .todo
        return imageView
    }()
    private let todoTitleLabel = {
        let label = UILabel()
        label.text = "오늘의 투두를 작성해보세요"
        label.textColor = .grey0
        label.font = Fonts.head2B
        return label
    }()
    private let todoSubTitleLabel = {
        let label = UILabel()
        label.text = "매일 자정부터 새로운 투두를 입력해요"
        label.textColor = .grey300
        label.font = Fonts.body2R
        return label
    }()
    private let todoButton = DogetherButton(title: "투두 작성하기", status: .enabled)
    
    private var allButton = FilterButton(action: { _ in }, type: .all)
    private var waitButton = FilterButton(action: { _ in }, type: .wait)
    private var rejectButton = FilterButton(action: { _ in }, type: .reject)
    private var approveButton = FilterButton(action: { _ in }, type: .approve)
    private func filterButtonStackView(buttons: [UIButton]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }
    private var filterStackView = UIStackView()
    private func todoItemStackView(items: [DogetherTodoItem]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: items)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }
    private var todoListStackView = UIStackView()
    
    private func emptyDescriptionView(type: FilterTypes) -> UIView {
        let view = UIView()
        
        let imageView = UIImageView(image: .comment)
        
        let label = UILabel()
        label.text = type.emptyDescription
        label.textColor = .grey400
        label.font = Fonts.head2B
        
        [imageView, label].forEach { view.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.equalTo(74)
            $0.height.equalTo(54)
        }
        
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(28)
        }
        
        return view
    }
    private var emptyDescriptionView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePushNotification(_:)),
            name: PushNoticeManager.pushNotificationReceived,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        timeProgress.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: timeProgress.bounds.width / 2, y: timeProgress.bounds.height / 2),
            radius: (timeProgress.bounds.width - 6) / 2,
            startAngle: -CGFloat.pi / 2,
            endAngle: 1.5 * CGFloat.pi,
            clockwise: true
        )
        
        timeProgressLayer.path = circlePath.cgPath
        timeProgressLayer.strokeEnd = viewModel.timeProgress
        timeProgress.layer.addSublayer(timeProgressLayer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // TODO: 임시로 모두 지웠다 다시 그리도록 구현, 추후 수정
        super.viewWillAppear(animated)
        Task { @MainActor in
            do {
                try await viewModel.getGroupStatus()
                try await viewModel.getGroupInfo()
                if viewModel.mainViewStatus != .beforeStart {
                    try await viewModel.getTodos()
                }
                
                try await viewModel.getReviews()
            } catch {
                // TODO: API 실패 시 처리에 대해 추후 논의
            }
            [dogetherHeader, groupInfoView, rankingButton, dogetherSheet].forEach { $0.removeFromSuperview() }
            
            [dogetherSheetHeaderLabel, beforeStartView, emptyListView, todoListView, filterStackView, emptyDescriptionView].forEach { $0.removeFromSuperview() }
            [
                timerView, timerInfoView, timeProgress, timerImageView, timerLabel,
                beforeStartTitleLabel, beforeStartSubTitleLabel
            ].forEach { $0.removeFromSuperview() }
            
            [todoImageView, todoTitleLabel, todoSubTitleLabel, todoButton].forEach { $0.removeFromSuperview() }
            
            [dogetherScrollView].forEach { $0.removeFromSuperview() }
            [todoListStackView].forEach { $0.removeFromSuperview() }
            
            configureView()
            configureHierarchy()
            configureConstraints()
        }
    }
    
    
    override func configureView() {
        groupInfoView = groupInfoView(groupInfo: viewModel.groupInfo)
        groupInfoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapGroupInfoView)))
        
        rankingButton.addTarget(self, action: #selector(didTapRankingButton), for: .touchUpInside)
        
        dogetherPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        dogetherPanGesture.delegate = self
        dogetherSheet.addGestureRecognizer(dogetherPanGesture)
        
        dogetherSheetHeaderLabel.text = DateFormatterManager.formattedDate(viewModel.dateOffset)
        
        dogetherScrollView.delegate = self
        dogetherScrollView.bounces = false
        dogetherScrollView.showsVerticalScrollIndicator = false
        
        beforeStartView = dogetherContentView(status: .beforeStart)
        emptyListView = dogetherContentView(status: .emptyList)
        todoListView = dogetherContentView(status: .todoList)
        
        timerLabel.text = viewModel.time
        
        todoButton.buttonTapped = { [weak self] in
            guard let self else { return }
            let todoWriteViewController = TodoWriteViewController()
            todoWriteViewController.maximumTodoCount = self.viewModel.groupInfo.maximumTodoCount
            NavigationManager.shared.pushViewController(todoWriteViewController)
        }
        
        allButton = FilterButton(action: {
            self.updateTodoList(type: $0)
        }, type: .all, isColorful: viewModel.currentFilter == .all)
        
        waitButton = FilterButton(action: {
            self.updateTodoList(type: $0)
        }, type: .wait, isColorful: viewModel.currentFilter == .wait)
        
        rejectButton = FilterButton(action: {
            self.updateTodoList(type: $0)
        }, type: .reject, isColorful: viewModel.currentFilter == .reject)
        
        approveButton = FilterButton(action: {
            self.updateTodoList(type: $0)
        }, type: .approve, isColorful: viewModel.currentFilter == .approve)
        
        filterStackView = filterButtonStackView(buttons: [allButton, waitButton, rejectButton, approveButton])
        
        
//        todoListStackView = todoItemStackView(
//            items: viewModel.todoList.map { todo in
//                DogetherTodoItem(action: {
//                    if TodoStatus(rawValue: todo.status) == .waitCertificattion {
//                        PopupManager.shared.showPopup(type: .certification, completion: {
//                            // TODO: 추후에 인증을 성공했을 때 UI 업데이트 등 추가
//                        }, todoInfo: todo)
//                    } else {
//                        PopupManager.shared.showPopup(type: .certificationInfo, todoInfo: todo)
//                    }
//                }, todo: todo)
//            }
//        )
        
        let mapTodoList = viewModel.todoList.map { todo in
            DogetherTodoItem(action: { [weak self] in
                guard let self else { return }
                if TodoStatus(rawValue: todo.status) == .waitCertificattion {
                    showPopup(type: .certification, todoInfo: todo) {
                        // TODO: 추후에 인증을 성공했을 때 UI 업데이트 등 추가
                        
                    }
                }
                else {
                    showPopup(type: .certificationInfo, todoInfo: todo)
                }
            }, todo: todo)
        }
        
        let _todoItemStackView = todoItemStackView(items: mapTodoList)
        self.todoListStackView = _todoItemStackView
        
        filterStackView.isHidden = viewModel.mainViewStatus != .todoList
        
        emptyDescriptionView = emptyDescriptionView(type: viewModel.currentFilter)
        emptyDescriptionView.isHidden = viewModel.mainViewStatus != .todoList || (viewModel.mainViewStatus == .todoList && !viewModel.todoList.isEmpty)
    }
    
    override func configureHierarchy() {
        [dogetherHeader, groupInfoView, rankingButton, dogetherSheet].forEach { view.addSubview($0) }
        
        [dogetherSheetHeaderLabel, beforeStartView, emptyListView, todoListView, filterStackView, emptyDescriptionView].forEach { dogetherSheet.addSubview($0) }
        [
            timerView, timerInfoView, timeProgress, timerImageView, timerLabel,
            beforeStartTitleLabel, beforeStartSubTitleLabel
        ].forEach { beforeStartView.addSubview($0) }
        
        [todoImageView, todoTitleLabel, todoSubTitleLabel, todoButton].forEach { emptyListView.addSubview($0) }
        
        [dogetherScrollView].forEach { todoListView.addSubview($0) }
        [todoListStackView].forEach { dogetherScrollView.addSubview($0) }
    }
    
    override func configureConstraints() {
        dogetherHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(24)
        }
        
        groupInfoView.snp.makeConstraints {
            $0.top.equalTo(dogetherHeader.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(97)
        }
        
        rankingButton.snp.makeConstraints {
            $0.top.equalTo(groupInfoView.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
        
        dogetherSheet.snp.makeConstraints {
            dogetherSheetTopConstraint = $0.top.equalTo(view.safeAreaLayoutGuide).offset(SheetStatus.normal.offset).constraint
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        dogetherSheetHeaderLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dogetherSheet).offset(24)
            $0.height.equalTo(28)
        }
        
        // MARK: - beforeStart
        beforeStartView.snp.makeConstraints {
            $0.top.equalTo(dogetherSheetHeaderLabel.snp.bottom).offset(24)
            $0.left.right.bottom.equalToSuperview()
        }
        
        timerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(142)
        }
        
        timeProgress.snp.makeConstraints {
            $0.edges.equalTo(timerView)
        }
        
        timerInfoView.snp.makeConstraints {
            $0.center.equalTo(timerView)
            $0.height.equalTo(58)
        }
        
        timerImageView.snp.makeConstraints {
            $0.centerX.equalTo(timerInfoView)
            $0.top.equalTo(timerInfoView)
            $0.width.height.equalTo(20)
        }
        
        timerLabel.snp.makeConstraints {
            $0.centerX.equalTo(timerInfoView)
            $0.bottom.equalTo(timerInfoView)
            $0.height.equalTo(36)
        }
        
        beforeStartTitleLabel.snp.makeConstraints {
            $0.top.equalTo(timerView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(28)
        }
        
        beforeStartSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(beforeStartTitleLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(21)
        }
        
        // MARK: - emptyList
        emptyListView.snp.makeConstraints {
            $0.top.equalTo(dogetherSheetHeaderLabel.snp.bottom).offset(24)
            $0.left.right.bottom.equalToSuperview()
        }
        
        todoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(202)
            $0.height.equalTo(131)
        }
        
        todoTitleLabel.snp.makeConstraints {
            $0.top.equalTo(todoImageView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(28)
        }
        
        todoSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(todoTitleLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(21)
        }
        
        todoButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(48)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        // MARK: - todoList
        filterStackView.snp.makeConstraints {
            $0.top.equalTo(dogetherSheetHeaderLabel.snp.bottom).offset(24)
            $0.left.equalToSuperview().offset(16)
        }
        
        todoListView.snp.makeConstraints {
            $0.top.equalTo(filterStackView.snp.bottom).offset(28)
            $0.width.equalToSuperview()
            $0.height.equalTo(viewModel.todoListHeight)
        }
        
        dogetherScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        todoListStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().inset(16)
        }
        
        emptyDescriptionView.snp.makeConstraints {
            $0.centerX.equalTo(todoListView)
            $0.top.equalTo(filterStackView.snp.bottom).offset(125)
            $0.width.equalTo(233)
            $0.height.equalTo(98)
        }
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        if viewModel.isBlockPanGesture { return }
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .changed:
            switch viewModel.sheetStatus {
            case .expand:
                if translation.y > 0 {
                    dogetherSheetTopConstraint?.update(offset: min(SheetStatus.normal.offset, translation.y))
                    view.layoutIfNeeded()
                }
            case .normal:
                if translation.y < 0 {
                    dogetherSheetTopConstraint?.update(offset: max(0, SheetStatus.normal.offset + translation.y))
                    view.layoutIfNeeded()
                }
            }
            
        case .ended:
            switch viewModel.sheetStatus {
            case .expand:
                if translation.y > 100 { updateSheetStatus(to: .normal) }
                else { updateSheetStatus(to: .expand) }
            case .normal:
                if translation.y < -100 { updateSheetStatus(to: .expand) }
                else { updateSheetStatus(to: .normal) }
            }
            
        default:
            break
        }
    }
    
    private func updateSheetStatus(to status: SheetStatus) {
        viewModel.setIsBlockPanGesture(true)
        UIView.animate(withDuration: 0.3) {
            self.dogetherSheetTopConstraint?.update(offset: status.offset)
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.viewModel.setIsBlockPanGesture(false)
            self.viewModel.updateSheetStatus(status)
        }
    }
    
    @objc private func didTapGroupInfoView() {
        present(UIActivityViewController(activityItems: [viewModel.groupInfo.joinCode], applicationActivities: nil), animated: true)
    }
    
    @objc private func didTapRankingButton() {
        NavigationManager.shared.pushViewController(RankingViewController())
    }
    
    private func updateTodoList(type: FilterTypes) {
        viewModel.updateFilter(type)
        allButton.setIsColorful(type == .all)
        waitButton.setIsColorful(type == .wait)
        rejectButton.setIsColorful(type == .reject)
        approveButton.setIsColorful(type == .approve)
        
        viewWillAppear(true)
    }
}

// MARK: - about pan gesture
extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        if viewModel.sheetStatus == .expand && dogetherScrollView.contentOffset.y > 0 { return false }
        return true
    }
}

// MARK: - about scroll
extension MainViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if viewModel.sheetStatus == .normal {
            scrollView.panGestureRecognizer.isEnabled = false
            scrollView.panGestureRecognizer.isEnabled = true
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if viewModel.sheetStatus == .normal || viewModel.isBlockPanGesture {
            scrollView.contentOffset.y = 0
            return
        }
    }
}

// MARK: - about push notice
extension MainViewController {
    @objc private func handlePushNotification(_ notification: Notification) {
        guard let notificationType = notification.userInfo?["type"] as? PushNoticeTypes,
              notificationType == .review else { return }
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let topViewController = window.rootViewController?.topMostViewController(),
           topViewController is MainViewController {
            viewWillAppear(true)
        }
    }
}

// TODO: 추후 수정 또는 삭제
extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presented = presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
}
