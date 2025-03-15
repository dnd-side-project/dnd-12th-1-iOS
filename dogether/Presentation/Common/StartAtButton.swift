//
//  StartAtButton.swift
//  dogether
//
//  Created by seungyooooong on 3/2/25.
//

import Foundation
import UIKit

final class StartAtButton: UIButton {
    private(set) var startAt: GroupStartAts
    private(set) var isColorful: Bool
    private(set) var action: (GroupStartAts) -> Void
    
    init(startAt: GroupStartAts, isColorful: Bool = false, action: @escaping (GroupStartAts) -> Void = { _ in }) {
        self.startAt = startAt
        self.isColorful = isColorful
        self.action = action
        
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private let icon = UIImageView()
    
    private let label = UILabel()
    
    private let descriptionLabel = UILabel()
    
    private func updateUI() {
        layer.borderColor = isColorful ? UIColor.blue300.cgColor : UIColor.grey800.cgColor
        
        icon.tintColor = isColorful ? .blue300 : .grey0
        
        label.textColor = isColorful ? .blue300 : .grey0
        
        descriptionLabel.textColor = isColorful ? .blue300 : .grey0
    }
    
    private func setUI() {
        updateUI()
        
        backgroundColor = .grey800
        layer.cornerRadius = 12
        layer.borderWidth = 1.5
        addTarget(self, action: #selector(didTapStartAtButton), for: .touchUpInside)
        
        icon.image = startAt.image.withRenderingMode(.alwaysTemplate)
        
        label.text = startAt.text + "시작"
        label.font = Fonts.body1B
        
        descriptionLabel.attributedText = NSAttributedString(
            string: startAt.description,
            attributes: Fonts.getAttributes(for: Fonts.body2R, textAlignment: .left)
        )
        descriptionLabel.numberOfLines = 0
        
        [icon, label, descriptionLabel].forEach { addSubview($0) }
        
        icon.snp.makeConstraints {
            $0.top.equalToSuperview().offset(26)
            $0.left.equalToSuperview().inset(20)
            $0.width.height.equalTo(24)
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(icon.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(25)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(12)
            $0.bottom.equalToSuperview().inset(27)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    func setAction(action: @escaping (GroupStartAts) -> Void) {
        self.action = action
    }
    
    func setColorful(isColorful: Bool) {
        self.isColorful = isColorful
        
        updateUI()
    }
    
    @objc private func didTapStartAtButton() {
        action(startAt)
    }
}

