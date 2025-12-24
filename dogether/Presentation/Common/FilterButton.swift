//
//  FilterButton.swift
//  dogether
//
//  Created by seungyooooong on 2/16/25.
//

import UIKit

final class FilterButton: BaseButton {
    var mainDelegate: MainDelegate? {
        didSet {
            addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    mainDelegate?.selectFilterAction(filterType: type)
                }, for: .touchUpInside
            )
        }
    }
    
    var certificationListDelegate: CertificationListPageDelegate? {
        didSet {
            addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    certificationListDelegate?.selectFilterAction(filterType: type)
                }, for: .touchUpInside
            )
        }
    }
    
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
        layer.cornerRadius = 16
        layer.borderWidth = 1
        
        icon.image = type.image?.withRenderingMode(.alwaysTemplate)
        
        label.text = type.rawValue
        label.font = Fonts.body2S
        
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.isUserInteractionEnabled = false
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        let views = icon.image == nil ? [label] : [icon, label]
        views.forEach { stackView.addArrangedSubview($0) }
        
        [stackView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        stackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(6)
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.center.equalToSuperview()
        }
        
        icon.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: any BaseEntity) {
        if let datas = data as? FilterTypes {
            let isColorful = type == datas
            
            backgroundColor = isColorful ? type.backgroundColor : .clear
            layer.borderColor = isColorful ? type.backgroundColor.cgColor : UIColor.grey500.cgColor
            icon.tintColor = isColorful ? .grey900 : .grey400
            label.textColor = isColorful ? .grey800 : .grey300
        }
    }
}
