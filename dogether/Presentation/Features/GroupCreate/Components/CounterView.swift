//
//  CounterView.swift
//  dogether
//
//  Created by seungyooooong on 2/10/25.
//

import UIKit

final class CounterView: BaseView {
    var delegate: GroupCreateDelegate? {
        didSet {
            [minusButton, plusButton].forEach { button in
                button.addAction(
                    UIAction { [weak self, weak button] _ in
                        guard let self, let currentCount, let button else { return }
                        delegate?.updateCountAction(currentCount: currentCount + button.tag, min: min, max: max)
                    }, for: .touchUpInside
                )
            }
        }
    }
    
    private let dogetherCountView = UIView()
    private let minusButton = UIButton()
    private let minusImageView = UIImageView()
    
    private let plusButton = UIButton()
    private let plusImageView = UIImageView()
    
    private let currentLabel = UILabel()
    private let minLabel = UILabel()
    private let maxLabel = UILabel()
    
    private let min: Int = 2
    private let max: Int = 20
    private let unit: String = "명"
    
    private var currentCount: Int?
    
    override func configureView() {
        dogetherCountView.backgroundColor = .grey800
        dogetherCountView.layer.cornerRadius = 12
        
        minusButton.tag = Directions.minus.tag
        minusButton.backgroundColor = .grey700
        minusButton.layer.cornerRadius = 8
        
        minusImageView.image = .minus.withRenderingMode(.alwaysTemplate)
        minusImageView.tintColor = .grey0
        minusImageView.isUserInteractionEnabled = false
        
        plusButton.tag = Directions.plus.tag
        plusButton.backgroundColor = .grey700
        plusButton.layer.cornerRadius = 8
        
        plusImageView.image = .plus.withRenderingMode(.alwaysTemplate)
        plusImageView.tintColor = .grey0
        plusImageView.isUserInteractionEnabled = false
        
        currentLabel.textColor = .grey0
        currentLabel.font = Fonts.body1S
        
        minLabel.text = "\(min)\(unit)"
        minLabel.textColor = .grey300
        minLabel.font = Fonts.body2S
        
        maxLabel.text = "\(max)\(unit)"
        maxLabel.textColor = .grey300
        maxLabel.font = Fonts.body2S
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [dogetherCountView, minLabel, maxLabel].forEach { addSubview($0) }
        [minusButton, minusImageView, plusButton, plusImageView, currentLabel].forEach {
            dogetherCountView.addSubview($0)
        }
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
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? GroupCreateViewDatas {
            if currentCount != datas.memberCount {
                currentCount = datas.memberCount
                
                currentLabel.text = "\(datas.memberCount)\(unit)"
            }
        }
    }
}
