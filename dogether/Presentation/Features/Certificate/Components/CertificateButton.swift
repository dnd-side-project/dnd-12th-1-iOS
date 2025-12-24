//
//  CertificateButton.swift
//  dogether
//
//  Created by seungyooooong on 12/9/25.
//

import UIKit

final class CertificateButton: BaseButton {
    private let type: CertificateTypes
    
    init(type: CertificateTypes) {
        self.type = type
        
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }

    private let iconImageView = UIImageView()
    private let label = UILabel()
    private let stackView = UIStackView()
    
    override func configureView() {
        layer.cornerRadius = 8
        backgroundColor = .grey700
        tag = type.rawValue
            
        iconImageView.image = type.image
        
        label.text = type.title
        label.textColor = .grey200
        label.font = Fonts.body1S
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.isUserInteractionEnabled = false
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [iconImageView, label].forEach { stackView.addArrangedSubview($0) }
        
        [stackView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        snp.makeConstraints {
            $0.height.equalTo(50)
        }
    }
}

enum CertificateTypes: Int {
    case gallery
    case camera
    
    var title: String {
        switch self {
        case .gallery:
            return "사진 선택"
        case .camera:
            return "사진 촬영"
        }
    }
    
    var image: UIImage {
        switch self {
        case .gallery:
            return .gallery
        case .camera:
            return .camera
        }
    }
}
