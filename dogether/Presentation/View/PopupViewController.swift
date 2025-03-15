//
//  PopupViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/15/25.
//

import Foundation
import UIKit
import SnapKit

/// 팝업 베이스 뷰컨을 만들었으니
/// 쪼개 주시길 바랍니다.
/// 코드 플로우가 복잡해서 분리하기가 까다롭습니다.
final class PopupViewController: BaseViewController {
    private var viewModel = PopupViewModel()
    
    var popupType: PopupTypes?
    var todoInfo: TodoInfo?
    var completeAction: ((String) -> Void)?
    
    private var cameraManager: CameraManager?
    
    private var galleryManager: GalleryManager?
    
    private let backgroundView = UIView()
    
    private var popupView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAct()
    }
    
    override func configureView() {
        setBackgroundView() // 백그라운드 세팅
        
        guard let popupType else { return }
        switch popupType {
        case .certification:
            guard let todoInfo else { return }
            
            let _popupView = CertificationPopupView(todoInfo: todoInfo, delegate: self)
            popupView = _popupView
            
            let _cameraManager = CameraManager(viewController: self)
            let _galleryManager = GalleryManager(viewController: self)
            self.cameraManager = _cameraManager
            self.galleryManager = _galleryManager
            
            _popupView.cameraManager = cameraManager
            _popupView.galleryManager = galleryManager
            
            _cameraManager.completion = { [weak self] image in
                guard let self else { return }
                uploadImage(view: _popupView, image: image)
            }
            
            _galleryManager.completion = { [weak self] image in
                guard let self else { return }
                uploadImage(view: _popupView, image: image)
            }
            
        case .certificationInfo:
            guard let todoInfo else { return }
            popupView = CertificationInfoPopupView(todoInfo: todoInfo) { [weak self] in
                guard let self else { return }
                dismissAct()
            }
            
        case .rejectReason:
            popupView = RejectReasonPopupView(
                completeAction: completeAction ?? { _ in },
                dismissAction: { [weak self] in
                    guard let self else { return }
                    dismissAct()
                }
            )
        }
    }
    
    override func configureHierarchy() {
        self.view.addSubview(backgroundView)
        self.view.addSubview(popupView)
    }
    
    override func configureConstraints() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        popupView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width * 0.85)
        }
    }
    
    private func uploadImage(view certificationPopupView: CertificationPopupView, image: UIImage?) {
        guard let image else { return }
        certificationPopupView.uploadImage(image: image)
        viewModel.uploadImage(image: image)
    }
    
    deinit {
        logger.debug("deinit PopupViewController")
    }
}

// MARK: UI
extension PopupViewController {
    /// background View Settings
    private func setBackgroundView() {
        self.view.backgroundColor = .clear
        
        // MARK: View Tap Gesture 대리자 에시
        self.backgroundView
            .addTapGesture { [weak self] in
                guard let self else { return }
                dismissAct()
            }
    }
     
    /// 뷰가 사라질때의 애니메이션을 정의합니다.
    private func dismissAct() {
        view.alpha = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) { [weak self] in
            guard let weakSelf = self else { return }
            UIView.animate(withDuration: 0.3) {
                weakSelf.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0)
                weakSelf.view.alpha = 0
            } completion: { _ in
                weakSelf.dismiss(animated: false)
            }
        }
    }
    
    /// 팝업 노출 효과를 정의합니다.
    private func showAct() {
        view.alpha = 0
        popupView.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) { [weak self] in
            guard let weakSelf = self else { return }
            UIView.animate(withDuration: 0.4) {
                weakSelf.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                weakSelf.view.alpha = 1
                weakSelf.popupView.alpha = 1
            }
        }
    }
    
}

// MARK: PopupDelegate
extension PopupViewController: CertificationPopupDelegate {
    func tossCertificationTextViewText(with text: String) {
        Task {
            try await self.viewModel.certifyTodo(todoId: self.todoInfo?.id ?? 0, certificationContent: text)
//            PopupManager.shared.hidePopup()
            self.dismissAct()
        }
    }
    
    func dismissAction() {
        self.dismissAct()
    }
}
