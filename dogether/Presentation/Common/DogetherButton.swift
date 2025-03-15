//
//  DogetherButton.swift
//  dogether
//
//  Created by seungyooooong on 2/9/25.
//

import UIKit
import SnapKit

final class DogetherButton: UIButton {
    private(set) var title: String
    
    /// 현재 버튼 상태를 정의합니다.
    private(set) var status: ButtonStatus
    
    init(title: String, status: ButtonStatus) {
        self.title = title
        self.status = status
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        logger.error("init(coder:) has not been implemented")
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UI
extension DogetherButton {
    
    private func setUI() {
        updateUI()
        
        setTitle(title, for: .normal)
        titleLabel?.font = Fonts.body1B
        layer.cornerRadius = 12
        
        self.snp.makeConstraints {
            $0.height.equalTo(50)
        }
    }
    
    private func updateUI() {
        setTitleColor(status.textColor, for: .normal)
        backgroundColor = status.backgroundColor
        isEnabled = status == .enabled
    }
}

// MARK: USE
extension DogetherButton {
    
    func setTitle(_ title: String) {
        self.title = title
    }
    
    /// 버튼 상태를 정의합니다.
    /// - Parameter status: 버튼 상태
    func setButtonStatus(status: ButtonStatus) {
        self.status = status
        updateUI()
    }
}
