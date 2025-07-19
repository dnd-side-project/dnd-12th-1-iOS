//
//  CertificationFilterView.swift
//  dogether
//
//  Created by yujaehong on 5/19/25.
//

import UIKit
import SnapKit

final class CertificationFilterView: BaseView {
    
    weak var delegate: BottomSheetDelegate?
    
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    let sortButton = CertificationSortButton()
    
    private var currentFilter: FilterTypes = .all   // FIXME: View에서 변수를 관리하는 건 좋지 않은 것 같아요 나중에 CertificationListViewModel로 빼주세요
    private var allButton = FilterButton(type: .all)
    private var waitButton = FilterButton(type: .wait)
    private var rejectButton = FilterButton(type: .reject)
    private var approveButton = FilterButton(type: .approve)
    
    var filterSelected: ((FilterTypes) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func configureView() {
        setFilter(filter: .all)
        setupScrollView()
        setupContentStackView()
        setupButtons()
    }
    
    override func configureAction() {
        // FIXME: View에서 Action을 들고있는 건 좋지 않은 것 같아요 나중에 CertificationListViewController로 빼주세요
        // ???: 다만, filterSelected에 넣지 않은 이유는 View -> ViewController 형태의 역방향 호출 방법에 대해 논의하고 싶어서입니다
        [allButton, waitButton, approveButton, rejectButton].forEach { button in
            button.addAction(
                UIAction { [weak self, weak button] _ in
                    guard let self, let button else { return }
                    Task { @MainActor in
                        self.setFilter(filter: button.type)
                    }
                }, for: .touchUpInside
            )
        }
    }
    
    override func configureHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentStackView)
    }
    
    override func configureConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        contentStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalToSuperview()
        }
    }
}

extension CertificationFilterView {
    private func setupScrollView() {
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    private func setupContentStackView() {
        contentStackView.axis = .horizontal
        contentStackView.spacing = 8
        contentStackView.alignment = .fill
        contentStackView.distribution = .fillProportionally
    }
    
    private func setupButtons() {
        sortButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                delegate?.presentBottomSheet()
            }, for: .touchUpInside
        )
        
        contentStackView.addArrangedSubview(sortButton)
        [allButton, waitButton, approveButton, rejectButton].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func setFilter(filter: FilterTypes) {
        if currentFilter == filter {
            currentFilter = .all
        } else {
            currentFilter = filter
        }
        
        filterSelected?(currentFilter)
        allButton.setIsColorful(currentFilter == .all)
        waitButton.setIsColorful(currentFilter == .wait)
        rejectButton.setIsColorful(currentFilter == .reject)
        approveButton.setIsColorful(currentFilter == .approve)
    }
}
