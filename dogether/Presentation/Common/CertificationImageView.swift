//
//  CertificationImageView.swift
//  dogether
//
//  Created by seungyooooong on 2/17/25.
//

import UIKit

final class CertificationImageView: BaseImageView {
    private let type: DefaultImageTypes
    
    private(set) var currentImageUrl: String?
    private(set) var currentContent: String?
    private(set) var currentCertificator: String?
    
    init(type: DefaultImageTypes) {
        self.type = type
        
        super.init()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let gradientLayer = CAGradientLayer()
    private let gradientView = UIView()
    
    private let certificationContentLabel = UILabel()
    private let certificatorLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientView.layer.sublayers?.first?.frame = gradientView.bounds
    }
    
    override func configureView() {
        image = type.image
        contentMode = .scaleAspectFit
        backgroundColor = .grey900
        clipsToBounds = true
        layer.cornerRadius = 12
        
        gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0.87).cgColor,
            UIColor.black.withAlphaComponent(0.37).cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.locations = [-0.2, 0.6]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.6)
        gradientLayer.cornerRadius = 12
        
        gradientView.layer.cornerRadius = 12
        gradientView.layer.borderColor = UIColor.grey700.cgColor
        gradientView.layer.borderWidth = 1
        
        certificationContentLabel.attributedText = NSAttributedString(
            string: type.content ?? "",
            attributes: Fonts.getAttributes(for: Fonts.body1R, textAlignment: .center)
        )
        certificationContentLabel.textColor = .grey0
        certificationContentLabel.numberOfLines = 0
        
        certificatorLabel.textColor = .grey100
        certificatorLabel.font = Fonts.head2B
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        gradientView.layer.addSublayer(gradientLayer)
        
        [gradientView, certificationContentLabel, certificatorLabel].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        gradientView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        certificationContentLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(32)
        }
        
        certificatorLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(0)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? CertificationImageViewDatas {
            if image != datas.image {
                image = datas.image
            }
            
            if currentImageUrl != datas.imageUrl {
                currentImageUrl = datas.imageUrl
                
                loadImage(url: datas.imageUrl, successAction: updateCertificationContentLabelConstraints)
            }
            
            if currentContent != datas.content {
                currentContent = datas.content
                
                certificationContentLabel.attributedText = NSAttributedString(
                    string: datas.content ?? "",
                    attributes: Fonts.getAttributes(for: Fonts.body1R, textAlignment: .center)
                )
            }
            
            if currentCertificator != datas.certificator {
                currentCertificator = datas.certificator
                
                certificatorLabel.text = datas.certificator
                
                certificatorLabel.snp.updateConstraints {
                    $0.height.equalTo(datas.certificator == nil ? 0 : 28)
                }
            }
            
            updateCertificationContentLabelConstraints()
        }
    }
}

extension CertificationImageView {
    private func updateCertificationContentLabelConstraints() {
        certificationContentLabel.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            if currentCertificator == nil {
                $0.bottom.equalToSuperview().inset(16)
            } else {
                $0.bottom.equalTo(certificatorLabel.snp.top).inset(4)
            }
        }
    }
}
