//
//  CounterView.swift
//  dogether
//
//  Created by seungyooooong on 2/10/25.
//

import UIKit

final class CounterView: BaseView {
    let min: Int
    let max: Int
    let unit: String
    let changeCountAction: (Int) -> Void
    private(set) var current: Int
    
    init(min: Int = 2, max: Int = 10, current: Int, unit: String, changeCountAction: @escaping (Int) -> Void) {
        self.min = min
        self.max = max
        self.current = current
        self.unit = unit
        self.changeCountAction = changeCountAction
        
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let dogetherCountView = {
        let view = UIView()
        view.backgroundColor = .grey800
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let minusButton = {
        let button = UIButton()
        button.tag = Directions.minus.tag
        button.backgroundColor = .grey700
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let minusImageView = {
        let imageView = UIImageView()
        imageView.image = .minus.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .grey0
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    private let plusButton = {
        let button = UIButton()
        button.tag = Directions.plus.tag
        button.backgroundColor = .grey700
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let plusImageView = {
        let imageView = UIImageView()
        imageView.image = .plus.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .grey0
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    private let currentLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.font = Fonts.body1S
        return label
    }()
    
    private let minLabel = {
        let label = UILabel()
        label.textColor = .grey300
        label.font = Fonts.body2S
        return label
    }()
    
    private let maxLabel = {
        let label = UILabel()
        label.textColor = .grey300
        label.font = Fonts.body2S
        return label
    }()
    
    override func configureView() {
        currentLabel.text = "\(current)\(unit)"
        minLabel.text = "\(min)\(unit)"
        maxLabel.text = "\(max)\(unit)"
    }
    
    override func configureAction() {
        [minusButton, plusButton].forEach { button in
            button.addAction(
                UIAction { [weak self, weak button] _ in
                    guard let self, let button else { return }
                    changeCount(tag: button.tag)
                }, for: .touchUpInside
            )
        }
    }
    
    override func configureHierarchy() {
        [dogetherCountView, minLabel, maxLabel].forEach { addSubview($0) }
        [minusButton, minusImageView, plusButton, plusImageView, currentLabel].forEach { dogetherCountView.addSubview($0) }
    }
    
    override func configureConstraints() {
        dogetherCountView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        minusButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(dogetherCountView).offset(5)
            $0.width.height.equalTo(40)
        }
        
        minusImageView.snp.makeConstraints {
            $0.center.equalTo(minusButton)
            $0.width.height.equalTo(24)
        }
        
        plusButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(dogetherCountView).offset(-5)
            $0.width.height.equalTo(40)
        }
        
        plusImageView.snp.makeConstraints {
            $0.center.equalTo(plusButton)
            $0.width.height.equalTo(24)
        }
        
        currentLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        minLabel.snp.makeConstraints {
            $0.top.equalTo(dogetherCountView.snp.bottom).offset(8)
            $0.left.equalToSuperview()
        }
        
        maxLabel.snp.makeConstraints {
            $0.top.equalTo(dogetherCountView.snp.bottom).offset(8)
            $0.right.equalToSuperview()
        }
    }
}
 
extension CounterView {
    private func changeCount(tag direction: Int) {
        let after = current + direction
        if min <= after && after <= max {
            self.setCurrent(after)
            changeCountAction(current)
        }
    }
    
    private func setCurrent(_ currentCount: Int) {
        self.current = currentCount
        currentLabel.text = "\(current)\(unit)"
    }
}
