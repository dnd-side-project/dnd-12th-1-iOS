//
//  BasePopUpView.swift
//  dogether
//
//  Created by Jae hyung Kim on 3/15/25.
//

import UIKit.UIView

protocol BasePopUpViewProtocol {
    var dismiss: (() -> Void)? { get set }
}

/// BasePopUpView 필수 구현 사항
///
///     /// 예시
///     class CustomPopupView: BasePopUpView {
///     private let closeButton = UIButton()
///
///     override init(frame: CGRect) {
///         super.init(frame: frame)
///         setupView()
///     }
///
///     required init?(coder: NSCoder) {
///         fatalError("init(coder:) has not been implemented")
///     }
///
///     private func setupView() {
///         addSubview(closeButton)
///         closeButton.setTitle("닫기", for: .normal)
///         closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
///     }
///
///     @objc private func closeButtonTapped() {
///         dismiss() // 팝업 내부에서 닫기 요청
///     }
///   }
class BasePopUpView: UIView, BasePopUpViewProtocol {
    var dismiss: (() -> Void)?
}
