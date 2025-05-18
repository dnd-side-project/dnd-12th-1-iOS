//
//  StartAtButton.swift
//  dogether
//
//  Created by seungyooooong on 3/2/25.
//

import UIKit

final class StartAtButton: BaseButton {
    private(set) var startAt: GroupStartAts
    private(set) var isColorful: Bool
    
    init(startAt: GroupStartAts, isColorful: Bool = false) {
        self.startAt = startAt
        self.isColorful = isColorful
        
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let icon = UIImageView()
    
    private let label = UILabel()
    
    private let descriptionLabel = UILabel()
    
    override func configureView() {
        updateUI()
        
        backgroundColor = .grey800
        layer.cornerRadius = 12
        layer.borderWidth = 1.5
        
        icon.image = startAt.image.withRenderingMode(.alwaysTemplate)
        
        label.text = startAt.text + "시작"
        label.font = Fonts.body1B
        
        descriptionLabel.attributedText = NSAttributedString(
            string: startAt.description,
            attributes: Fonts.getAttributes(for: Fonts.body2R, textAlignment: .left)
        )
        descriptionLabel.numberOfLines = 0
    }
    
    override func configureAction() { }
        
    override func configureHierarchy() {
        [icon, label, descriptionLabel].forEach { addSubview($0) }
    }
     
    override func configureConstraints() {
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
    
    private func updateUI() {
        layer.borderColor = isColorful ? UIColor.blue300.cgColor : UIColor.grey800.cgColor
        
        icon.tintColor = isColorful ? .blue300 : .grey0
        
        label.textColor = isColorful ? .blue300 : .grey0
        
        descriptionLabel.textColor = isColorful ? .blue300 : .grey0
    }
    
    func setColorful(isColorful: Bool) {
        self.isColorful = isColorful
        
        updateUI()
    }
}

