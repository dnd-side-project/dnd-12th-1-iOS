//
//  DurationButton.swift
//  dogether
//
//  Created by seungyooooong on 3/2/25.
//

import UIKit

final class DurationButton: BaseButton {
    var delegate: GroupCreateDelegate? {
        didSet {
            addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.updateDuration(duration: duration)
                }, for: .touchUpInside
            )
        }
    }
    
    private let duration: GroupChallengeDurations
    
    init(duration: GroupChallengeDurations) {
        self.duration = duration
        
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let label = UILabel()
    
    private var currentDuration: GroupChallengeDurations?
    
    override func configureView() {
        backgroundColor = .grey800
        layer.cornerRadius = 12
        layer.borderWidth = 1.5
        
        label.text = duration.text
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [label].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? GroupChallengeDurations {
            if currentDuration != datas {
                currentDuration = datas
                
                let isColorful = duration == datas
                layer.borderColor = isColorful ? UIColor.blue300.cgColor : UIColor.grey800.cgColor
                
                label.textColor = isColorful ? .blue300 : .grey0
                label.font = isColorful ? Fonts.body1B : Fonts.body1S
            }
        }
    }
}
