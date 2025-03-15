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
    
    private let groupInfoView = GroupInfoView()
    
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
    
    private let beforeStartView = UIView()
    private let emptyListView = UIView()
    private let todoListView = UIView()
    
    private let timerView = {
        let view = UIView()
        view.backgroundColor = .grey700
        view.layer.cornerRadius = 142 / 2
        
        let imageView = UIImageView()
        imageView.image = .wait.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .blue300
        
        [imageView].forEach { view.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-20)
            $0.width.height.equalTo(20)
        }
        
        return view
    }()
    
    private let timeProgress = {
        let view = UIView()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.blue300.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 6
        
        let viewSize: CGFloat = 142
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: viewSize / 2, y: viewSize / 2),
            radius: (viewSize - 6) / 2,
            startAngle: -CGFloat.pi / 2,
            endAngle: 1.5 * CGFloat.pi,
            clockwise: true
        )
        
        shapeLayer.path = circlePath.cgPath
        view.layer.addSublayer(shapeLayer)
            
        return view
    }()
    
    private let timerLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.font = Fonts.head1B
        return label
    }()
    
    private let timerDescription = {
        let title = UILabel()
        title.text = "내일부터 투두를 시작할 수 있어요!"
        title.textColor = .grey0
        title.font = Fonts.head2B
        
        let subTitle = UILabel()
        subTitle.text = "오늘은 계획을 세우고, 내일부터 실천해보세요!"
        subTitle.textColor = .grey300
        subTitle.font = Fonts.body2R
        
        let stackView = UIStackView(arrangedSubviews: [title, subTitle])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        
        title.snp.makeConstraints {
            $0.height.equalTo(28)
        }
        
        subTitle.snp.makeConstraints {
            $0.height.equalTo(21)
        }
        
        return stackView
    }()
    
    private let todoView = {
        let imageView = UIImageView(image: .todo)
        imageView.contentMode = .scaleAspectFit
        
        let title = UILabel()
        title.text = "오늘의 투두를 작성해보세요"
        title.textColor = .grey0
        title.font = Fonts.head2B
        
        let subTitle = UILabel()
        subTitle.text = "매일 자정부터 새로운 투두를 입력해요"
        subTitle.textColor = .grey300
        subTitle.font = Fonts.body2R
        
        let stackView = UIStackView(arrangedSubviews: [imageView, title, subTitle])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.setCustomSpacing(10, after: imageView)
        stackView.setCustomSpacing(4, after: title)
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width * 0.53)
            if let image = imageView.image {
                $0.height.equalTo(imageView.snp.width).multipliedBy(image.size.height / image.size.width)
            }
        }
        
        title.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(28)
        }
        
        subTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(21)
        }
        
        return stackView
    }()
    
    private let todoButton = DogetherButton(title: "투두 작성하기", status: .enabled)
    
    private let allButton = FilterButton(type: .all)
    private let waitButton = FilterButton(type: .wait)
    private let rejectButton = FilterButton(type: .reject)
    private let approveButton = FilterButton(type: .approve)
    
    private func filterStackView(buttons: [UIButton]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }
    private var filterStackView = UIStackView()
    
    private let todoScrollView = UIScrollView()
    
    private let todoListStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    final class EmptyDescriptionView: UIView {
        private(set) var type: FilterTypes = .all
        
        private let imageView = UIImageView(image: .comment)
        
        private let label = UILabel()
        
        init() {
            super.init(frame: .zero)
            
            setUI()
        }
        
        required init?(coder: NSCoder) { fatalError() }
        
        private func updateUI() {
            label.text = type.emptyDescription
        }
        
        private func setUI() {
            updateUI()
            
            label.textColor = .grey400
            label.font = Fonts.head2B
            
            [imageView, label].forEach { self.addSubview($0) }
            
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
        }
        
        func setType(_ type: FilterTypes) {
            self.type = type
            
            updateUI()
        }
    }
    private var emptyDescriptionView = EmptyDescriptionView()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.loadMainView(updateView: updateView, updateTimer: updateTimer, updateList: updateList)
    }
    
    override func configureView() {
        rankingButton.addTarget(self, action: #selector(didTapRankingButton), for: .touchUpInside)
        
        dogetherPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        dogetherPanGesture.delegate = self
        dogetherSheet.addGestureRecognizer(dogetherPanGesture)
        
        todoScrollView.delegate = self
        todoScrollView.bounces = false
        todoScrollView.showsVerticalScrollIndicator = false
        
        todoButton.addTarget(self, action: #selector(didTapTodoButton), for: .touchUpInside)
        
        allButton.setAction { self.viewModel.updateFilter(filter: $0, completeAction: self.updateList) }
        waitButton.setAction { self.viewModel.updateFilter(filter: $0, completeAction: self.updateList) }
        rejectButton.setAction { self.viewModel.updateFilter(filter: $0, completeAction: self.updateList) }
        approveButton.setAction { self.viewModel.updateFilter(filter: $0, completeAction: self.updateList) }
        
        filterStackView = filterStackView(buttons: [allButton, waitButton, rejectButton, approveButton])
    }
    
    override func configureHierarchy() {
        [dogetherHeader, groupInfoView, rankingButton, dogetherSheet].forEach { view.addSubview($0) }
        
        [dogetherSheetHeaderLabel, beforeStartView, emptyListView, todoListView].forEach { dogetherSheet.addSubview($0) }
        
        [timerView, timeProgress, timerLabel, timerDescription,].forEach { beforeStartView.addSubview($0) }
        
        [todoView, todoButton].forEach { emptyListView.addSubview($0) }
        
        [todoScrollView, filterStackView, emptyDescriptionView].forEach { todoListView.addSubview($0) }
        [todoListStackView].forEach { todoScrollView.addSubview($0) }
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
            $0.bottom.left.right.equalToSuperview()
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
        
        timerLabel.snp.makeConstraints {
            $0.centerX.equalTo(timerView)
            $0.centerY.equalTo(timerView).offset(11)
            $0.height.equalTo(36)
        }
        
        timerDescription.snp.makeConstraints {
            $0.top.equalTo(timerView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
        
        // MARK: - emptyList
        emptyListView.snp.makeConstraints {
            $0.top.equalTo(dogetherSheetHeaderLabel.snp.bottom)
            $0.bottom.left.right.equalToSuperview()
        }
        
        todoView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-49)
        }
        
        todoButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(48)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        // MARK: - todoList
        todoListView.snp.makeConstraints {
            $0.top.equalTo(dogetherSheetHeaderLabel.snp.bottom)
            $0.bottom.left.right.equalToSuperview()
        }
        
        filterStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.left.equalToSuperview().offset(16)
        }
        
        todoScrollView.snp.makeConstraints {
            $0.top.equalTo(filterStackView.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
        
        todoListStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview() // MARK: item 대신 stackView에서 너비 지정
        }
        
        emptyDescriptionView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(filterStackView.snp.bottom).offset(125)
            $0.width.equalTo(233)
            $0.height.equalTo(98)
        }
    }
    
    @objc private func didTapRankingButton() {
        viewModel.navigateToRankingView()
    }
    
    @objc private func didTapTodoButton() {
        viewModel.navigateToTodoWriteView()
    }
}

// MARK: - update UI
extension MainViewController {
    private func updateSheet(_ status: SheetStatus) {
        viewModel.setIsBlockPanGesture(true)
        UIView.animate(withDuration: 0.3) {
            self.dogetherSheetTopConstraint?.update(offset: status.offset)
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.viewModel.setIsBlockPanGesture(false)
        }
    }
    
    private func updateView() {
        groupInfoView.setGroupInfo(groupInfo: viewModel.groupInfo)
        
        dogetherSheetHeaderLabel.text = DateFormatterManager.formattedDate(viewModel.dateOffset)
        
        beforeStartView.isHidden = viewModel.mainViewStatus != .beforeStart
        emptyListView.isHidden = viewModel.mainViewStatus != .emptyList
        todoListView.isHidden = viewModel.mainViewStatus != .todoList
    }
    
    private func updateTimer() {
        timerLabel.text = viewModel.time
        (timeProgress.layer.sublayers?.first as? CAShapeLayer)?.strokeEnd = viewModel.timeProgress
    }
    
    private func updateList() {
        // TODO: 추후 MainViewStatus와 GroupStatus를 통합할 때 개선 필요
        emptyListView.isHidden = viewModel.mainViewStatus != .emptyList
        todoListView.isHidden = viewModel.mainViewStatus != .todoList
        
        allButton.setIsColorful(viewModel.currentFilter == .all)
        waitButton.setIsColorful(viewModel.currentFilter == .wait)
        rejectButton.setIsColorful(viewModel.currentFilter == .reject)
        approveButton.setIsColorful(viewModel.currentFilter == .approve)
        
        filterStackView.isHidden = viewModel.mainViewStatus != .todoList
        
        todoListStackView.isHidden = viewModel.todoList.isEmpty
        todoListStackView.subviews.forEach { todoListStackView.removeArrangedSubview($0) }
        
        // MARK: ❤️‍🔥 자꾸... 이러시면....!
        /// 흠 이부분은 음.. ViewModel과 View를 결국 소통은 해야하는데
        /// 싱글톤으로 하지마시구... ( 예를 들어 다른 뷰모델이랑 이벤트가 동시에 발생 된다고 생각해 보시면 문제가 커집니다....
        /// 뷰 모델에서 명령을 하는건 좋은것 같아요.
        /// 결국 뷰가 뷰를 볼러와야 하니까 뷰에게 명령해야지 다른 대리자가 윈도우, 뷰컨을 막 순회해서 뷰를 띄운다고 하면
        /// 매번... 호출할때마다 뷰컨을 순회하게 됩니다... 한번 고민 부탁드려요..
        ///
//        viewModel.todoList
//            .map { todo in TodoListItemButton(todo: todo) { self.viewModel.didTapTodoItem(todo: $0) } }
//            .forEach { todoListStackView.addArrangedSubview($0) }
//        
        // MARK: - FIXME
        viewModel.todoList
            .map { todoInfo in
                TodoListItemButton(todo: todoInfo) { [weak self] todo in
                    guard let weakSelf = self else { return }
                    
                    let popupType: PopupTypes = TodoStatus(rawValue: todo.status) == .waitCertificattion ? .certification : .certificationInfo
                    
                    weakSelf.showPopup(type: popupType, todoInfo: todo)
                }
            }
            .forEach { todoListStackView.addArrangedSubview($0) }
        
        emptyDescriptionView.isHidden = !(viewModel.mainViewStatus == .todoList && viewModel.todoList.isEmpty)
        emptyDescriptionView.setType(viewModel.currentFilter)
    }
}

// MARK: - about pan gesture
extension MainViewController: UIGestureRecognizerDelegate {
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        if viewModel.isBlockPanGesture { return }
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .changed:
            dogetherSheetTopConstraint?.update(
                offset: viewModel.getNewOffset(
                    from: dogetherSheetTopConstraint?.layoutConstraints.first?.constant ?? 0,
                    with: translation.y
                )
            )
            view.layoutIfNeeded()
            
        case .ended:
            viewModel.updateSheetStatus(with: translation.y, completeAction: updateSheet)
            
        default:
            break
        }
    }
    
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        if viewModel.sheetStatus == .expand && todoScrollView.contentOffset.y > 0 { return false }
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
