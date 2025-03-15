//
//  FilterButton.swift
//  dogether
//
//  Created by seungyooooong on 2/16/25.
//

import Foundation
import UIKit

final class FilterButton: UIButton {
    let type: FilterTypes
    private(set) var isColorful: Bool
    private(set) var action: (FilterTypes) -> Void
    
    init(type: FilterTypes, isColorful: Bool = true, action: @escaping (FilterTypes) -> Void = { _ in }) {
        self.type = type
        self.isColorful = isColorful
        self.action = action
        
        super.init(frame: .zero)
        setUI()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private var icon = UIImageView()
    
    private var label = UILabel()
    
    private var stackView = UIStackView()
    
    private func updateUI() {
        backgroundColor = isColorful ? type.backgroundColor : .grey800
        layer.borderColor = isColorful ? type.backgroundColor.cgColor : UIColor.grey500.cgColor
        icon.tintColor = isColorful ? .grey900 : .grey400
        label.textColor = isColorful ? .grey900 : .grey400
    }
    
    private func setUI() {
        updateUI()
        
        layer.cornerRadius = 16
        layer.borderWidth = 1
        addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
        
        icon.image = type.image?.withRenderingMode(.alwaysTemplate)
        
        label.text = type.rawValue
        label.font = Fonts.body2S
        
        let views = icon.image == nil ? [label] : [icon, label]
        stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.isUserInteractionEnabled = false
        
        [stackView].forEach { addSubview($0) }
        
        self.snp.makeConstraints {
            $0.width.equalTo(type.width)
        }

        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        icon.snp.makeConstraints {
            $0.width.height.equalTo(type == .wait ? 18 : type == .reject ? 22 : 24)    // MARK: 임의로 사이즈 조정
        }
    }
    
    func setAction(_ action: @escaping (FilterTypes) -> Void) {
        self.action = action
    }
    
    func setIsColorful(_ isColorful: Bool) {
        self.isColorful = isColorful
        
        updateUI()
    }
    
    @objc private func didTapFilterButton() {
        action(type)
    }
}
