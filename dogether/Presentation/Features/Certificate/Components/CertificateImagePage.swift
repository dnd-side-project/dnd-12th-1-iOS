//
//  CertificateImagePage.swift
//  dogether
//
//  Created by seungyooooong on 12/9/25.
//

import UIKit

import PhotosUI

final class CertificateImagePage: BasePage {
    var delegate: CertificateImageDelegate? {
        didSet {
            certificateButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.goCertificateContentViewAction()
                }, for: .touchUpInside
            )
        }
    }
    
    private let navigationHeader = NavigationHeader(title: "인증 하기")
    private let imageView = CertificationImageView(type: .camera)
    private let todoContentLabel = UILabel()
    private let galleryButton = CertificateButton(type: .gallery)
    private let cameraButton = CertificateButton(type: .camera)
    private let certificationStackView = UIStackView()
    private let certificateButton = DogetherButton("다음")
    
    override func configureView() {
        todoContentLabel.textColor = .grey0
        todoContentLabel.numberOfLines = 0
        
        certificationStackView.axis = .horizontal
        certificationStackView.spacing = 11
        certificationStackView.distribution = .fillEqually
    }
    
    override func configureAction() {
        navigationHeader.delegate = coordinatorDelegate
        
        [galleryButton, cameraButton].forEach { button in
            button.addAction(
                UIAction { [weak self, weak button] _ in
                    guard let self, let button,
                          let type = CertificateTypes(rawValue: button.tag) else { return }
                    switch type {
                    case .gallery:
                        checkGalleryAuthorization()
                    case .camera:
                        checkCameraAuthorization()
                    }
                }, for: .touchUpInside
            )
        }
    }
    
    override func configureHierarchy() {
        [galleryButton, cameraButton].forEach { certificationStackView.addArrangedSubview($0) }
        
        [ navigationHeader, imageView,
          todoContentLabel, certificationStackView, certificateButton
        ].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.width.equalToSuperview().offset(-(16 * 2))
            $0.height.equalTo(imageView.snp.width)
        }
        
        todoContentLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(36)
        }
        
        certificationStackView.snp.makeConstraints {
            $0.top.equalTo(todoContentLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        certificateButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? CertificateViewDatas {
            todoContentLabel.attributedText = NSAttributedString(
                string: datas.todo.content,
                attributes: Fonts.getAttributes(for: Fonts.head1B, textAlignment: .center)
            )
        }
        
        if let datas = data as? DogetherButtonViewDatas {
            certificateButton.updateView(datas)
        }
    }
}

// MARK: - about gallery
extension CertificateImagePage: PHPickerViewControllerDelegate {
    private func checkGalleryAuthorization() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .authorized, .limited:
            openGallery()
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                Task { @MainActor in
                    if status == .authorized || status == .limited { self.openGallery() }
                    else { self.delegate?.showPopupAction(type: .gallery) }
                }
            }
            
        case .denied, .restricted:
            delegate?.showPopupAction(type: .gallery)
            
        @unknown default:
            break
        }
    }
    
    private func openGallery() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        delegate?.presentPickerControllerAction(pickerController: picker)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
        provider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
            guard let self,
                  let uiImage = image as? UIImage,
                  let compressImage = uiImage.compressImage(),
                  let pngData = compressImage.pngData(),
                  let pngImage = UIImage(data: pngData) else { return }
            Task { @MainActor in
                self.pickerCompletion(image: pngImage)
            }
        }
    }
}

// MARK: - about camera
extension CertificateImagePage: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func checkCameraAuthorization() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            openCamera()
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                Task { @MainActor in
                    if granted { self.openCamera() }
                    else { self.delegate?.showPopupAction(type: .camera) }
                }
            }
            
        case .denied, .restricted:
            delegate?.showPopupAction(type: .camera)
            
        @unknown default:
            break
        }
    }
    
    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = false
        delegate?.presentPickerControllerAction(pickerController: picker)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        picker.dismiss(animated: true)
        
        guard let uiImage = info[.originalImage] as? UIImage,
              let compressImage = uiImage.compressImage(),
              let pngData = compressImage.pngData(),
              let pngImage = UIImage(data: pngData) else { return }
        pickerCompletion(image: pngImage)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension CertificateImagePage {
    private func pickerCompletion(image: UIImage) {
        let certificationImageViewDatas = CertificationImageViewDatas(image: image, content: "")
        imageView.updateView(certificationImageViewDatas)
        
        delegate?.uploadImageAction(image: image)
    }
}
