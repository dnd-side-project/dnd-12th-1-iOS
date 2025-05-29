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
    private var filterButtons: [FilterButton] = []
    
    var filterSelected: ((FilterTypes) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func configureView() {
        setupScrollView()
        setupContentStackView()
        setupButtons()
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
            $0.edges.equalToSuperview()
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
        let filterTypes: [FilterTypes] = [.wait, .approve, .reject]
        
        filterButtons = filterTypes.map { type in
            let button = FilterButton(type: type, isColorful: false)
            button.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    handleFilterButtonTapped(button)
                }, for: .touchUpInside
            )
            return button
        }
        
        sortButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                delegate?.presentBottomSheet()
            }, for: .touchUpInside
        )
        
        contentStackView.addArrangedSubview(sortButton)
        filterButtons.forEach {
            contentStackView.addArrangedSubview($0)
        }
    }
    
    private func handleFilterButtonTapped(_ sender: FilterButton) {
        let isCurrentlyActive = sender.isColorful
          if isCurrentlyActive {
              sender.setIsColorful(false)
              filterSelected?(.all)
          } else {
              filterButtons.forEach { $0.setIsColorful(false) }
              sender.setIsColorful(true)
              filterSelected?(sender.type)
          }
    }
}
