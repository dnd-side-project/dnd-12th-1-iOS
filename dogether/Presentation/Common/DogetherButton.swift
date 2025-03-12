//
//  DogetherButton.swift
//  dogether
//
//  Created by seungyooooong on 2/9/25.
//

import UIKit
import SnapKit

final class DogetherButton: UIButton {
    
    /// 타이틀을 정의합니다.
    private(set) var title: String
    
    /// 현재 버튼 상태를 정의합니다.
    private(set) var status: ButtonStatus
    
    /// 버튼 선택을 정의합니다.
    var buttonTapped: (() -> Void)?
    
    init(title: String, status: ButtonStatus, buttonTapped: (() -> Void)? = nil) {
        self.title = title
        self.status = status
        self.buttonTapped = buttonTapped
        super.init(frame: .zero)
        setUI()
        setAction()
    }
    
    required init?(coder: NSCoder) {
        logger.error("\(#file) can not init")
        fatalError()
    }
    
    private let dogetherButton = UIButton()
        .setOf {
            $0.titleLabel?.font = Fonts.body1B
            $0.layer.cornerRadius = 12
        }
}

// MARK: UI
extension DogetherButton {
    
    private func setUI() {
        self.dogetherButton.setTitle(title, for: .normal)
        self.dogetherButton.setTitleColor(status.textColor, for: .normal)
        self.dogetherButton.backgroundColor = status.backgroundColor
        self.dogetherButton.isEnabled = status == .enabled
        
        self.addSubview(dogetherButton)
        
        dogetherButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
}

// MARK: Action
extension DogetherButton {

    /// 버튼 액션을 정의합니다.
    private func setAction() {
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            buttonTapped?()
        }
        dogetherButton.addAction(action, for: .touchDown)
    }
}

// MARK: USE
extension DogetherButton {
    
    /// 버튼 액션 정의가 애매합니다..
    /// - Parameter action: <#action description#>
//    func setAction(_ action: @escaping () -> Void) {
//        self.action = action
//    }
    
    /// 버튼 타이틀을 정의합니다.
    /// - Parameter title: 타이틀정의
    func setTitle(_ title: String) {
        self.title = title
        dogetherButton.setTitle(self.title, for: .normal)
    }
    
    /// 버튼 상태를 정의합니다.
    /// - Parameter status: 버튼 상태
    func setButtonStatus(status: ButtonStatus) {
        self.status = status
        dogetherButton.setTitleColor(status.textColor, for: .normal)
        dogetherButton.backgroundColor = status.backgroundColor
        dogetherButton.isEnabled = status == .enabled
    }
}
