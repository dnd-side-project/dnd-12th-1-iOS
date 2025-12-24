//
//  ExaminateButton.swift
//  dogether
//
//  Created by seungyooooong on 12/4/25.
//

import UIKit

final class ExaminateButton: BaseButton {
    private let type: FilterTypes
    
    init(type: FilterTypes) {
        self.type = type
        
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let icon = UIImageView()
    private let label = UILabel()
    private let stackView = UIStackView()
    
    override func configureView() {
        backgroundColor = .grey0
        layer.cornerRadius = 8
        tag = type.tag
        
        icon.image = type.image?.withRenderingMode(.alwaysTemplate)
        icon.tintColor = .grey700
        
        label.text = type.rawValue
        label.textColor = .grey700
        label.font = Fonts.body1S
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.isUserInteractionEnabled = false
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [icon, label].forEach { stackView.addArrangedSubview($0) }
        
        [stackView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        icon.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: UIColor) {
        backgroundColor = data
    }
}
