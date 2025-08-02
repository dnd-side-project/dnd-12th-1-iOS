//
//  BottomSheetViewController.swift
//  dogether
//
//  Created by yujaehong on 4/28/25.
//

import UIKit

protocol BottomSheetItemRepresentable {
    var bottomSheetItem: BottomSheetItem { get }
}

protocol BottomSheetDelegate: AnyObject {
    func presentBottomSheet()
}

struct BottomSheetItem: Hashable {
    let displayName: String
    let value: AnyHashable
}

final class BottomSheetViewController: BaseViewController {
    
    // MARK: - Properties
    var onDismiss: (() -> Void)?
    var didSelectOption: ((BottomSheetItem) -> Void)?
    
    private let titleText: String
    private var selectedItem: BottomSheetItem?
    private let bottomSheetItem: [BottomSheetItem]
    private weak var overlayView: UIView?
    private let shouldShowAddGroupButton: Bool
    
    // UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey700
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .grey0
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let bottomSpacerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    private let addGroupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("새 그룹 추가하기", for: .normal)
        button.setTitleColor(.grey200, for: .normal)
        button.titleLabel?.font = Fonts.body1S
        button.backgroundColor = .clear
        button.contentHorizontalAlignment = .leading
        
        button.setImage(.plus2, for: .normal)
        button.tintColor = .grey200
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()

    // MARK: - Initializer
    
    init(titleText: String, bottomSheetItem: [BottomSheetItem], shouldShowAddGroupButton: Bool = false, selectedItem: BottomSheetItem?) {
        self.titleText = titleText
        self.bottomSheetItem = bottomSheetItem
        self.shouldShowAddGroupButton = shouldShowAddGroupButton
        self.selectedItem = selectedItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addOverlay()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeOverlay()
    }
    
    // MARK: - Setup Methods
    
    override func configureView() {
        view.backgroundColor = .clear
        titleLabel.text = titleText
        tableView.register(BottomSheetCell.self, forCellReuseIdentifier: "BottomSheetCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false 
    }
    
    override func configureAction() {
        addGroupButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                dismiss(animated: true) {
                    let startViewController = StartViewController()
                    startViewController.isFirst = false
                    self.coordinator?.pushViewController(startViewController)
                }
            }, for: .touchUpInside
        )
    }
    
    override func configureHierarchy() {
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(tableView)
        if shouldShowAddGroupButton {
            containerView.addSubview(addGroupButton)
        }
        containerView.addSubview(bottomSpacerView)
    }
    
    override func configureConstraints() {
        let tableViewHeight = CGFloat(bottomSheetItem.count * 49)
        var containerHeight = tableViewHeight + 28 + 25 + 48
        if shouldShowAddGroupButton { containerHeight += 50 }
        
        containerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(containerHeight)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(containerView).inset(24)
            $0.leading.equalTo(containerView).inset(24)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel).inset(30)
            $0.leading.trailing.equalTo(containerView)
            $0.height.equalTo(tableViewHeight)
        }
        
        if shouldShowAddGroupButton {
            addGroupButton.snp.makeConstraints {
                $0.top.equalTo(tableView.snp.bottom)
                $0.leading.trailing.equalTo(containerView).inset(24)
                $0.height.equalTo(50)
            }

            bottomSpacerView.snp.makeConstraints {
                $0.top.equalTo(addGroupButton.snp.bottom)
                $0.leading.trailing.equalTo(containerView)
                $0.height.equalTo(48)
                $0.bottom.equalTo(containerView)
            }
        } else {
            bottomSpacerView.snp.makeConstraints {
                $0.top.equalTo(tableView.snp.bottom)
                $0.leading.trailing.equalTo(containerView)
                $0.height.equalTo(48)
                $0.bottom.equalTo(containerView)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        // 터치한 위치가 containerView 외부일 경우 dismiss
        guard let touch = touches.first else { return }
        let location = touch.location(in: view)
        if !containerView.frame.contains(location) {
            dismiss(animated: true)
        }
    }
}

extension BottomSheetViewController {
    private func addOverlay() {
        guard let presentingView = presentingViewController?.view else { return }
        let overlay = UIView(frame: presentingView.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlay.alpha = 0.0
        presentingView.addSubview(overlay)
        presentingView.bringSubviewToFront(overlay)
        
        UIView.animate(withDuration: 0.3) {
            overlay.alpha = 1.0
        }
        
        self.overlayView = overlay
    }
    
    private func removeOverlay() {
        UIView.animate(withDuration: 0.3, animations: {
            self.overlayView?.alpha = 0.0
        }, completion: { _ in
            self.overlayView?.removeFromSuperview()
        })
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension BottomSheetViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bottomSheetItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BottomSheetCell", for: indexPath) as! BottomSheetCell
        let option = bottomSheetItem[indexPath.row]
        
        let isSelected = option == selectedItem
        cell.configure(option: option.displayName, isSelected: isSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = bottomSheetItem[indexPath.row]
        selectedItem = item
        tableView.reloadData()

        Task {
            try? await Task.sleep(nanoseconds: 100_000_000)
            didSelectOption?(item)
            dismiss(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 49
    }
}
