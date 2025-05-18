//
//  DogetherButton.swift
//  dogether
//
//  Created by seungyooooong on 2/9/25.
//

import UIKit

final class DogetherButton: BaseButton {
    private(set) var title: String
    private(set) var status: ButtonStatus
    
    init(title: String, status: ButtonStatus) {
        self.title = title
        self.status = status
        
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func configureView() {
        updateUI()
        
        setTitle(title, for: .normal)
        titleLabel?.font = Fonts.body1B
        layer.cornerRadius = 12
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() { }
    
    override func configureConstraints() {
        self.snp.makeConstraints {
            $0.height.equalTo(50)
        }
    }
}
 
extension DogetherButton {
    private func updateUI() {
        setTitleColor(status.textColor, for: .normal)
        backgroundColor = status.backgroundColor
        isEnabled = status == .enabled
    }
    
    func setTitle(_ title: String) {
        self.title = title
    }
    
    func setButtonStatus(status: ButtonStatus) {
        self.status = status
        
        updateUI()
    }
}
