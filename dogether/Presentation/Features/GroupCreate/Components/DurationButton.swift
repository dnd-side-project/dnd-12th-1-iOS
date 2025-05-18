//
//  DurationButton.swift
//  dogether
//
//  Created by seungyooooong on 3/2/25.
//

import UIKit

final class DurationButton: BaseButton {
    private(set) var duration: GroupChallengeDurations
    private(set) var isColorful: Bool
    
    init(duration: GroupChallengeDurations, isColorful: Bool = false) {
        self.duration = duration
        self.isColorful = isColorful
        
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let label = UILabel()
    
    override func configureView() {
        updateUI()
        
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
}
 
extension DurationButton {
    private func updateUI() {
        layer.borderColor = isColorful ? UIColor.blue300.cgColor : UIColor.grey800.cgColor
        
        label.textColor = isColorful ? .blue300 : .grey0
        label.font = isColorful ? Fonts.body1B : Fonts.body1S
    }
    
    func setColorful(isColorful: Bool) {
        self.isColorful = isColorful
        
        updateUI()
    }
}
