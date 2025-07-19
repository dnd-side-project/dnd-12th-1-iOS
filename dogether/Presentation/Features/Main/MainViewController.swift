//
//  MainViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/13/25.
//

import UIKit
import SnapKit

final class MainViewController: BaseViewController {
    let viewModel = MainViewModel()
    
    private var dogetherPanGesture: UIPanGestureRecognizer!
    private var dogetherSheetTopConstraint: Constraint?
    
    private let dogetherHeader = DogetherHeader()
    
    private let dosikImageView = UIImageView(image: .noteDosik)
    
    private let dosikCommentButton = DosikCommentButton()
    
    private let groupInfoView = GroupInfoView()
    
    private var errorView: ErrorView?
    
    private var bottomSheetViewController: BottomSheetViewController?
    
    private let rankingButton = {
        let button = UIButton()
        button.backgroundColor = .grey700
        button.layer.cornerRadius = 8
        
        let imageView = UIImageView(image: .chart)
        imageView.isUserInteractionEnabled = false
        
        let label = UILabel()
        label.text = "그룹 활동 한눈에 보기 !"
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
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let sheetHeaderView = SheetHeaderView()
    
    private let timerView = TimerView()
    private let todoListView = TodoListView()
    private let todayEmptyView = TodayEmptyView()
    private let pastEmptyView = PastEmptyView()
    private let doneView = DoneView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkAuthorization()
        coordinator?.updateViewController = loadMainView
        
        // ???: 화면 전환을 고려하면 일부러 강한 참조를 걸어야할까
        // TODO: 알림 권한을 거부한 사용자에 대한 로직은 추후에 추가
        Task { [weak self] in
            guard let self else { return }
            let reviews = try await viewModel.getReviews()
            if reviews.isEmpty { return }
            
            await MainActor.run {
                self.coordinator?.showModal(reviews: reviews)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadMainView()
    }
    
    override func configureView() {
        [timerView, todoListView, todayEmptyView, pastEmptyView, doneView].forEach { $0.isHidden = true }
    }
    
    override func configureAction() {
        dogetherHeader.delegate = self
        
        let groupNameTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedGroupNameStackView))
        groupInfoView.groupNameStackView.addGestureRecognizer(groupNameTapGesture)
        
        let joinCodeTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedJoinCodeStackView))
        groupInfoView.joinCodeStackView.addGestureRecognizer(joinCodeTapGesture)
        
        rankingButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                let rankingViewController = RankingViewController()
                rankingViewController.viewModel.groupId = viewModel.currentGroup.id
                coordinator?.pushViewController(rankingViewController)
            }, for: .touchUpInside
        )
        
        dogetherPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        dogetherPanGesture.delegate = self
        dogetherSheet.addGestureRecognizer(dogetherPanGesture)
        
        [sheetHeaderView.prevButton, sheetHeaderView.nextButton].forEach { button in
            button.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    let newOffset = viewModel.dateOffset + button.tag
                    viewModel.setFilter(filter: .all)
                    viewModel.setDateOffset(offset: newOffset)
                    Task {
                        try await self.viewModel.updateListInfo()
                        await MainActor.run {
                            self.updateView()
                            self.updateList()
                        }
                    }
                }, for: .touchUpInside
            )
        }
        
        todoListView.todoScrollView.delegate = self
        
        [todoListView.allButton, todoListView.waitButton, todoListView.rejectButton, todoListView.approveButton].forEach { button in
            button.addAction(
                UIAction { [weak self, weak button] _ in
                    guard let self, let button else { return }
                    self.viewModel.setFilter(filter: button.type)
                    Task { @MainActor in
                        self.updateList()
                    }
                }, for: .touchUpInside
            )
        }
        
        [todoListView.addTodoButton, todayEmptyView.todoButton].forEach { button in
            button.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    let todoWriteViewController = TodoWriteViewController()
                    todoWriteViewController.viewModel.groupId = viewModel.currentGroup.id
                    todoWriteViewController.viewModel.todos = viewModel.todoList.map { WriteTodoInfo(content: $0.content, enabled: false) }
                    coordinator?.pushViewController(todoWriteViewController)
                }, for: .touchUpInside
            )
        }
    }
    
    override func configureHierarchy() {
        [dogetherHeader, dosikImageView, dosikCommentButton, groupInfoView, rankingButton, dogetherSheet].forEach { view.addSubview($0) }
        
        [sheetHeaderView, timerView, todoListView, todayEmptyView, pastEmptyView, doneView].forEach { dogetherSheet.addSubview($0) }
    }
    
    override func configureConstraints() {
        dogetherHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        dosikImageView.snp.makeConstraints {
            $0.top.equalTo(dogetherHeader.snp.bottom)
            $0.right.equalToSuperview().inset(16)
            $0.width.height.equalTo(120)
        }
        
        dosikCommentButton.snp.makeConstraints {
            $0.bottom.equalTo(dosikImageView.snp.top).offset(-6)
            $0.right.equalTo(dosikImageView)
        }
        
        groupInfoView.snp.makeConstraints {
            $0.top.equalTo(dogetherHeader.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(36 + 12 + 45 + 16 + 21)   // FIXME: GroupInfoView 자체를 StackView로 전환
        }
        
        rankingButton.snp.makeConstraints {
            $0.top.equalTo(groupInfoView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
        
        dogetherSheet.snp.makeConstraints {
            dogetherSheetTopConstraint = $0.top.equalTo(view.safeAreaLayoutGuide).offset(SheetStatus.normal.offset).constraint
            $0.bottom.left.right.equalToSuperview()
        }
        
        sheetHeaderView.snp.makeConstraints {
            $0.top.equalTo(dogetherSheet).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(32)
        }
        
        [timerView, todoListView, todayEmptyView, pastEmptyView, doneView].forEach {
            $0.snp.makeConstraints {
                $0.top.equalTo(sheetHeaderView.snp.bottom)
                $0.bottom.equalTo(view.safeAreaLayoutGuide)
                $0.horizontalEdges.equalToSuperview()
            }
        }
    }
}

extension MainViewController {
    // MARK: () -> Void 타입이어야 updateViewController지정 가능
    private func loadMainView() {
        loadMainView(selectedIndex: nil)
    }
    
    private func loadMainView(selectedIndex: Int?) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let (groupIndex, newChallengeGroupInfos) = try await viewModel.getChallengeGroupInfos()

                if newChallengeGroupInfos.isEmpty {
                    await MainActor.run {
                        self.coordinator?.setNavigationController(StartViewController())
                    }
                    return
                }

                viewModel.setChallengeIndex(index: selectedIndex ?? groupIndex ?? 0)
                viewModel.setChallengeGroupInfos(challengegroupInfos: newChallengeGroupInfos)

                configureBottomSheetViewController()

                if viewModel.currentGroup.status == .ready {
                    viewModel.startCountdown(updateTimer: updateTimer, updateList: updateList)
                }

                try await viewModel.updateListInfo()

                await MainActor.run {
                    self.errorView?.removeFromSuperview()
                    self.errorView = nil
                    self.showMainContentViews()
                    self.updateView()
                    self.updateList()
                }
            } catch let error as NetworkError {
                await MainActor.run {
                    self.hideMainContentViews()
                    self.showErrorView(error: error)
                }
            }

        }
    }
}

// MARK: - update UI
extension MainViewController {
    private func checkAuthorization() {
        Task { [weak self] in
            guard let self else { return }
            let userNoti = UNUserNotificationCenter.current()
            let settings = await userNoti.notificationSettings()
            
            switch settings.authorizationStatus {
            case .notDetermined:
                try await userNoti.requestAuthorization(options: [.alert, .badge, .sound])
            case .denied:
                await MainActor.run {
                    self.coordinator?.showPopup(
                        self,
                        type: .alert,
                        alertType: .pushNotice,
                        completion:  { _ in
                            SystemManager().openSettingApp()
                        }
                    )
                }
            default:    // MARK: .authorized, .provisional, .ephemeral
                break
            }
        }
    }
    
    private func updateSheet(_ status: SheetStatus) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            dogetherSheetTopConstraint?.update(offset: status.offset)
            updateAlpha(alpha: status == .normal ? 1 : 0)
            view.layoutIfNeeded()
        }
    }
    
    private func updateAlpha(alpha: CGFloat) {
        [dosikImageView, groupInfoView.groupInfoStackView, groupInfoView.durationStackView, rankingButton].forEach {
            $0.alpha = alpha
        }
    }
    
    private func updateView() {
        groupInfoView.setChallengeGroupInfo(challengeGroupInfo: viewModel.currentGroup)
        
        let currentDate = DateFormatterManager.formattedDate(viewModel.dateOffset)
        sheetHeaderView.setDate(date: currentDate)
        sheetHeaderView.prevButton.isEnabled = viewModel.dateOffset * -1 < viewModel.currentGroup.duration - 1
        sheetHeaderView.nextButton.isEnabled = viewModel.dateOffset < 0
        
        timerView.isHidden = !(viewModel.currentGroup.status == .ready)
        todoListView.isHidden = viewModel.todoList.isEmpty
        todayEmptyView.isHidden = !(viewModel.todoList.isEmpty && viewModel.dateOffset == 0) || viewModel.currentGroup.status != .running
        pastEmptyView.isHidden = !(viewModel.todoList.isEmpty && viewModel.dateOffset < 0)
        doneView.isHidden = !(viewModel.currentGroup.status == .dDay && viewModel.dateOffset == 0)
        
        dosikCommentButton.updateUI(
            comment: viewModel.currentGroup.status == .dDay ? "그룹이 종료됐어요!" :
                viewModel.currentGroup.progress >= 1.0 ? "마지막 인증일이에요!\n내일부터 인증이 불가능해요." : nil
        )
    }
    
    private func updateTimer() {
        timerView.updateTimer(time: viewModel.time, timeProgress: viewModel.timeProgress)
    }
    
    func updateList() {
        todoListView.updateList(todoList: viewModel.todoList, filter: viewModel.currentFilter, isToday: viewModel.dateOffset == 0)
        
        todoListView.todoListStackView.arrangedSubviews.forEach { todoListItemView in
            guard let todoListItemButton = todoListItemView as? TodoListItemButton else { return }
            todoListItemButton.addAction(
                UIAction { [weak self, weak todoListItemButton] _ in
                    guard let self, let button = todoListItemButton else { return }
                    let isCertification = TodoStatus(rawValue: button.todo.status) == .waitCertification
                    if isCertification {
                        if button.isToday {
                            let certificationViewController = CertificationViewController()
                            certificationViewController.todoInfo = button.todo
                            coordinator?.pushViewController(certificationViewController)
                        } else { return }
                    } else {
                        let certificationInfoViewController = CertificationInfoViewController()
                        certificationInfoViewController.todoInfo = button.todo
                        coordinator?.pushViewController(certificationInfoViewController)
                    }
                }, for: .touchUpInside
            )
        }
    }
    
    @objc private func tappedGroupNameStackView() {
        presentBottomSheet()
    }
    
    @objc private func tappedJoinCodeStackView() {
        let inviteGroup = SystemManager.inviteGroup(groupName: viewModel.currentGroup.name, joinCode: viewModel.currentGroup.joinCode)
        present(UIActivityViewController(activityItems: inviteGroup, applicationActivities: nil), animated: true)
    }
}

// MARK: - about pan gesture
extension MainViewController: UIGestureRecognizerDelegate {
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .changed:
            let newOffset = viewModel.getNewOffset(
                from: dogetherSheetTopConstraint?.layoutConstraints.first?.constant ?? 0,
                with: translation.y
            )
            dogetherSheetTopConstraint?.update(offset: newOffset)
            updateAlpha(alpha: 1 - (SheetStatus.normal.offset - newOffset) / (SheetStatus.normal.offset - SheetStatus.expand.offset))
            view.layoutIfNeeded()
            
        case .ended:
            updateSheet(viewModel.updateSheetStatus(with: translation.y))
            
        default:
            break
        }
    }
    
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        if viewModel.sheetStatus == .expand && todoListView.todoScrollView.contentOffset.y > 0 { return false }
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
        if viewModel.sheetStatus == .normal {
            scrollView.contentOffset.y = 0
            return
        }
    }
}

// MARK: - about bottom sheet
extension MainViewController: BottomSheetDelegate {
    private func configureBottomSheetViewController() {
        let bottomSheetItem = viewModel.challengeGroupInfos.map { $0.bottomSheetItem }
        let selectedItem = viewModel.currentGroup.bottomSheetItem
        
        if bottomSheetItem.isEmpty { return }

        bottomSheetViewController = BottomSheetViewController(titleText: "그룹 선택",
                                                              bottomSheetItem: bottomSheetItem,
                                                              shouldShowAddGroupButton: viewModel.challengeGroupInfos.count < 5,
                                                              selectedItem: selectedItem)
        
        bottomSheetViewController?.coordinator = self.coordinator
        bottomSheetViewController?.modalPresentationStyle = .overCurrentContext
        bottomSheetViewController?.modalTransitionStyle = .coverVertical
        
        bottomSheetViewController?.didSelectOption = { [weak self] selectedItem in
            guard let self,
                  let selectedGroup = selectedItem.value as? ChallengeGroupInfo,
                  let selectedIndex = viewModel.challengeGroupInfos.firstIndex(of: selectedGroup) else { return }
            
            viewModel.setChallengeIndex(index: selectedIndex)
            viewModel.saveLastSelectedGroup()
            viewModel.setDateOffset(offset: 0)
            loadMainView(selectedIndex: selectedIndex)
        }
    }
    
    func presentBottomSheet() {
        if presentedViewController == nil,
           let bottomSheetViewController {
            present(bottomSheetViewController, animated: true)
        }
    }
}

// MARK: - ErrorView
extension MainViewController {
    private func showErrorView(error: NetworkError) {
        errorView?.removeFromSuperview()
        errorView = ErrorHandlingManager.embedErrorView(
            in: self,
            under: dogetherHeader,
            error: error,
            retryHandler: { [weak self] in
                guard let self else { return }
                self.loadMainView()
            }
        )
    }
    
    private func showMainContentViews() {
        [timerView, todoListView, todayEmptyView, pastEmptyView, doneView,
         dogetherSheet, rankingButton, dosikCommentButton, dosikImageView, groupInfoView]
            .forEach { $0.isHidden = false }
    }
    
    private func hideMainContentViews() {
        [timerView, todoListView, todayEmptyView, pastEmptyView, doneView,
         dogetherSheet, rankingButton, dosikCommentButton, dosikImageView, groupInfoView]
            .forEach { $0.isHidden = true }
    }
}
