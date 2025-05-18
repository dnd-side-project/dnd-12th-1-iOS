//
//  CertificationFilterView.swift
//  dogether
//
//  Created by yujaehong on 4/23/25.
//

import UIKit
import SnapKit

final class CertificationFilterView: BaseView {
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    let sortButton = CertificationSortButton() // 투두 완료일순, 그룹 생성일순
    private var filterButtons: [FilterButton] = [] // 검사대기, 인정, 노인정
    
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
        setupFilterButtons()
    }
    
    override func configureAction() {
        // 뷰 초기화가 끝난 뒤, sortButton을 눌린 상태로 세팅
        DispatchQueue.main.async { [weak self] in
            self?.sortButtonTapped()
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
    
    private func setupFilterButtons() {
        let filterTypes: [FilterTypes] = [.wait, .approve, .reject]
        
        filterButtons = filterTypes.map { type in
            let button = FilterButton(type: type)
            button.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    self.handleFilterButtonTapped(button)
                }, for: .touchUpInside
            )
            return button
        }
        
        sortButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                self.sortButtonTapped()
            }, for: .touchUpInside
        )
        
        contentStackView.addArrangedSubview(sortButton)
        filterButtons.forEach {
            contentStackView.addArrangedSubview($0)
        }
    }
    
    private func handleFilterButtonTapped(_ sender: FilterButton) {
        updateButtonStates(except: sender)
        filterSelected?(sender.type) // // 필터 상태 선택 시, 해당 타입 반환
    }
    
    private func sortButtonTapped() {
        updateButtonStates(except: sortButton)
    }
    
    private func updateButtonStates(except selectedButton: UIButton) {
        // 모든 버튼의 활성화 상태를 해제하고, 색상을 기본으로 설정
        filterButtons.forEach { $0.setIsColorful(false) }
        sortButton.setIsSelectedFilter(false)
        
        // 선택된 버튼은 활성화 상태로 설정
        if let selectedFilterButton = selectedButton as? FilterButton {
            selectedFilterButton.setIsColorful(true)
        } else if let selectedSortButton = selectedButton as? CertificationSortButton {
            filterSelected?(.all) // '전체' 필터 상태로 변경
            selectedSortButton.setIsSelectedFilter(true)
        }
    }
}
