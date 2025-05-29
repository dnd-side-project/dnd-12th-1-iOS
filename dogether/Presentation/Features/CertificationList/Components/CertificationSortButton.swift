//
//  CertificationSortButton.swift
//  dogether
//
//  Created by yujaehong on 5/19/25.
//

import UIKit

final class CertificationSortButton: BaseButton {
    
    let sortTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let arrowButton: UIButton = {
        let button = UIButton()
        button.setImage(.chevronDownBlue, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureView() {
        backgroundColor = .clear
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor.grey500.cgColor
        clipsToBounds = true
    }
    
    override func configureHierarchy() {
        addSubview(sortTitleLabel)
        addSubview(arrowButton)
    }
    
    override func configureConstraints() {
        snp.makeConstraints {
            $0.width.equalTo(116)
            $0.height.equalTo(32)
        }
        
        sortTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        
        arrowButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(19)
        }
    }
    
    func updateSelectedOption(_ option: BottomSheetItem) {
        sortTitleLabel.text = option.displayName
    }
}
