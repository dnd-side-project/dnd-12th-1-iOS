//
//  FilterButton.swift
//  dogether
//
//  Created by seungyooooong on 2/16/25.
//

import UIKit

final class FilterButton: BaseButton {
    var delegate: MainDelegate? {
        didSet {
            addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.selectFilterAction(filterType: type)
                }, for: .touchUpInside
            )
        }
    }
    
    // FIXME: CertificationListView RxSwift 도입 후 private 추가
    let type: FilterTypes
    private(set) var isColorful: Bool
    
    init(type: FilterTypes, isColorful: Bool = true) {
        self.type = type
        self.isColorful = isColorful
        
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private var icon = UIImageView()
    
    private var label = UILabel()
    
    private let stackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.isUserInteractionEnabled = false
        return stackView
    }()
    
    override func configureView() {
        updateUI()
        
        layer.cornerRadius = 16
        layer.borderWidth = 1
        
        icon.image = type.image?.withRenderingMode(.alwaysTemplate)
        
        label.text = type.rawValue
        label.font = Fonts.body2S
        
        let views = icon.image == nil ? [label] : [icon, label]
        views.forEach { stackView.addArrangedSubview($0) }
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [stackView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        self.snp.makeConstraints {
            $0.width.equalTo(type.width)
        }
        
        stackView.snp.makeConstraints {
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
            label.textColor = isColorful ? .grey900 : .grey400
        }
    }
}

extension FilterButton {
    private func updateUI() {
        backgroundColor = isColorful ? type.backgroundColor : .clear
        layer.borderColor = isColorful ? type.backgroundColor.cgColor : UIColor.grey500.cgColor
        icon.tintColor = isColorful ? .grey900 : .grey400
        label.textColor = isColorful ? .grey900 : .grey400
    }
    
    func setIsColorful(_ isColorful: Bool) {
        self.isColorful = isColorful
        
        updateUI()
    }
}

extension FilterButton {
    func update(type: FilterTypes, isColorful: Bool = true) {
        // icon, label, 색, width 전부 갱신
        self.icon.image = type.image?.withRenderingMode(.alwaysTemplate)
        self.label.text = type.rawValue
        self.isColorful = isColorful
        
        backgroundColor = isColorful ? type.backgroundColor : .grey800
        layer.borderColor = isColorful ? type.backgroundColor.cgColor : UIColor.grey500.cgColor
        icon.tintColor = isColorful ? .grey900 : .grey400
        label.textColor = isColorful ? .grey900 : .grey400
        
        icon.snp.updateConstraints {
            $0.width.height.equalTo(18)
        }
        
        // 너비도 갱신
        self.snp.updateConstraints {
            $0.width.equalTo(type.width)
        }
    }
}
