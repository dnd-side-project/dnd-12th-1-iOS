//
//  BottomSheetView.swift
//  dogether
//
//  Created by seungyooooong on 9/14/25.
//

import UIKit
import SnapKit

final class BottomSheetView: BaseView {
    var mainDelegate: MainDelegate? {
        didSet {
            backgroundView.addTapAction { [weak self] _ in
                guard let self else { return }
                mainDelegate?.updateBottomSheetVisibleAction(isShowSheet: false)
            }
        }
    }
    
    var statsDelegate: StatsDelegate? {
        didSet {
            backgroundView.addTapAction { [weak self] _ in
                guard let self else { return }
                statsDelegate?.updateBottomSheetVisibleAction(isShowSheet: false)
            }
        }
    }
    
    var certificationDelegate: CertificationListPageDelegate? {
        didSet {
            backgroundView.addTapAction { [weak self] _ in
                guard let self else { return }
                certificationDelegate?.updateBottomSheetVisibleAction(isShowSheet: false)
            }
        }
    }
    
    private let hasAddButton: Bool
    
    init(hasAddButton: Bool = true) {
        self.hasAddButton = hasAddButton
        
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private(set) var backgroundView = UIView()
    private(set) var sheetView = UIView()
    
    private(set) var sheetTitleLabel = UILabel()
    private(set) var itemListStackView = UIStackView()
    
    private(set) var sheetHeight: CGFloat = 0
    
    override func configureView() {
        alpha = 0
        
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)  // FIXME: 추후 ColorBackgroundDim 으로 변경
        
        sheetView.backgroundColor = .grey700
        sheetView.layer.cornerRadius = 12
        sheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        sheetTitleLabel.textColor = .grey0
        sheetTitleLabel.font = Fonts.head2B
        
        itemListStackView.axis = .vertical
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [backgroundView, sheetView].forEach { addSubview($0) }
        [sheetTitleLabel, itemListStackView].forEach { sheetView.addSubview($0) }
    }
    
    override func configureConstraints() {
        backgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-UIApplication.safeAreaOffset.top)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
        
        sheetView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(UIApplication.safeAreaOffset.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(0)
        }
        
        sheetTitleLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(24)
        }
        
        itemListStackView.snp.makeConstraints {
            $0.top.equalTo(sheetTitleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: any BaseEntity) {
        if let data = data as? GroupViewDatas {
            sheetTitleLabel.text = "그룹 선택"
            itemListStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            sheetHeight = 24 + 28 + 20
            + 49 * CGFloat(data.groups.count < 5 && hasAddButton ? data.groups.count + 1 : data.groups.count)
            + UIApplication.safeAreaOffset.bottom
            
            data.groups.enumerated().forEach { index, group in
                itemListStackView.addArrangedSubview(
                    itemButton(index: index, title: group.name, isSelected: index == data.index)
                )
            }
            
            if data.groups.count < 5 && hasAddButton {
                itemListStackView.addArrangedSubview(addGroupButton())
            }
        }
        
        if let data = data as? SortViewDatas {
            sheetTitleLabel.text = "정렬"
            itemListStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

            sheetHeight = 24 + 28 + 20
                + 49 * CGFloat(data.options.count)
                + UIApplication.safeAreaOffset.bottom

            data.options.enumerated().forEach { index, option in
                itemListStackView.addArrangedSubview(
                    itemButton(index: index, title: option.displayName, isSelected: index == data.index)
                )
            }
        }
        
        if let data = data as? BottomSheetViewDatas {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) { [weak self] in
                guard let self else { return }
                alpha = data.isShowSheet ? 1 : 0
                
                sheetView.snp.updateConstraints {
                    $0.height.equalTo(data.isShowSheet ? self.sheetHeight : 0)
                }
                layoutIfNeeded()
            }
        }
    }
}

// MARK: - private func
extension BottomSheetView {
    private func itemButton(index: Int, title: String, isSelected: Bool) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .grey700
        button.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                if let delegate = mainDelegate {
                    delegate.updateBottomSheetVisibleAction(isShowSheet: false)
                    delegate.selectGroupAction(index: index)
                }
                if let delegate = statsDelegate {
                    delegate.updateBottomSheetVisibleAction(isShowSheet: false)
                    delegate.selectGroupAction(index: index)
                }
                if let delegate = certificationDelegate {
                    delegate.updateBottomSheetVisibleAction(isShowSheet: false)
                    delegate.selectSortAction(index: index)
                }
            }, for: .touchUpInside
        )
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = isSelected ? .blue300 : .grey400
        titleLabel.font = isSelected ? Fonts.body1B : Fonts.body1S
        
        let checkImageView = UIImageView(image: .check)
        checkImageView.isHidden = !isSelected
        
        [titleLabel, checkImageView].forEach { button.addSubview($0) }
        
        button.snp.makeConstraints {
            $0.height.equalTo(49)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(24)
            $0.right.equalTo(checkImageView.snp.left)
        }
        
        checkImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
            $0.right.equalToSuperview().inset(24)
        }
        
        return button
    }
    
    private func addGroupButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .grey700
        button.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                if let delegate = mainDelegate {
                    delegate.updateBottomSheetVisibleAction(isShowSheet: false)
                    delegate.addGroupAction()
                }
            }, for: .touchUpInside
        )
        
        let addGroupImageView = UIImageView(image: .plusCircle)
        
        let titleLabel = UILabel()
        titleLabel.text = "새 그룹 추가하기"
        titleLabel.textColor = .grey200
        titleLabel.font = Fonts.body1B
        
        [addGroupImageView, titleLabel].forEach { button.addSubview($0) }
        
        button.snp.makeConstraints {
            $0.height.equalTo(49)
        }
        
        addGroupImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
            $0.left.equalToSuperview().inset(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(addGroupImageView.snp.right).offset(8)
        }
        
        return button
    }
}
