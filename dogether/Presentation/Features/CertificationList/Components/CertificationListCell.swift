//
//  CertificationListCell.swift
//  dogether
//
//  Created by yujaehong on 4/23/25.
//

import UIKit

final class CertificationCell: UICollectionViewCell {
    static let reuseIdentifier = "CertificationCell"
    
    private let imageView = UIImageView()
    private let statusButton = TodoStatusButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(statusButton)
        
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        statusButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-12)
        }
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    func configure(with certificationItem: TodoEntity) {
        imageView.loadImage(url: certificationItem.certificationMediaUrl)
        
        statusButton.updateView(certificationItem.status)
    }
}
