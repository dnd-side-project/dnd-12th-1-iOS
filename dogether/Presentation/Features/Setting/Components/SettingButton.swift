//
//  SettingButton.swift
//  dogether
//
//  Created by seungyooooong on 11/23/25.
//

import UIKit

final class SettingButton: BaseButton {
    private let title: String
    private let text: String?
    
    init(title: String, text: String? = nil) {
        self.title = title
        self.text = text
        
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let buttonTitleLabel = UILabel()
    private let textLabel = UILabel()
    private let chevronImageView = UIImageView(image: .chevronRight.withRenderingMode(.alwaysTemplate))
    
    override func configureView() {
        buttonTitleLabel.text = title
        buttonTitleLabel.textColor = .grey0
        buttonTitleLabel.font = Fonts.body1B
        
        textLabel.text = text
        textLabel.textColor = .grey0
        textLabel.font = Fonts.body1R
        textLabel.isHidden = text == nil
        
        chevronImageView.tintColor = .grey200
        chevronImageView.isHidden = text != nil
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [buttonTitleLabel, textLabel, chevronImageView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        self.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        
        buttonTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(8)
        }
        
        textLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(8)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(8)
            $0.width.height.equalTo(20)
        }
    }
}
