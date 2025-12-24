//
//  CertificateImageViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/12/25.
//

import UIKit

final class CertificateImageViewController: BaseViewController {
    private let certificateImagePage = CertificateImagePage()
    private let viewModel = CertificateViewModel()
    
    override func viewDidLoad() {
        certificateImagePage.delegate = self
        
        pages = [certificateImagePage]

        super.viewDidLoad()
    }
    
    override func setViewDatas() {
        if let datas = datas as? CertificateViewDatas {
            viewModel.certificateViewDatas.accept(datas)
        }
        
        bind(viewModel.certificateViewDatas)
        bind(viewModel.certificateButtonViewDatas)
    }
}

protocol CertificateImageDelegate {
    func goCertificateContentViewAction()
    func showPopupAction(type: AlertTypes)
    func presentPickerControllerAction(pickerController: UIViewController)
    func uploadImageAction(image: UIImage)
}

extension CertificateImageViewController: CertificateImageDelegate {
    func goCertificateContentViewAction() {
        let certificateContentViewController = CertificateContentViewController()
        let certificateViewDatas = viewModel.certificateViewDatas.value
        coordinator?.pushViewController(certificateContentViewController, datas: certificateViewDatas)
    }
    
    func showPopupAction(type: AlertTypes) {
        coordinator?.showPopup(type: .alert, alertType: type) { _ in
            SystemManager().openSettingApp()
        }
    }
    
    func presentPickerControllerAction(pickerController: UIViewController) {
        present(pickerController, animated: true)
    }
    
    func uploadImageAction(image: UIImage) {
        // FIXME: 추후 S3Manager를 NetworkManager로 합치면서 loading 로직도 제거해요
        Task {
            viewModel.updateButtonStatus(status: .disabled)
            
            LoadingManager.shared.showLoading()
            defer { LoadingManager.shared.hideLoading() }
            
            do {
                try await viewModel.uploadImage(image: image)
                viewModel.updateButtonStatus(status: .enabled)
            } catch {
                // TODO: 예외 케이스 핸들링
            }
        }
    }
}
