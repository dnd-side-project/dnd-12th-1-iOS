//
//  CertificationListCell.swift
//  dogether
//
//  Created by yujaehong on 4/23/25.
//

import UIKit
import Kingfisher

final class CertificationCell: UICollectionViewCell {
    static let reuseIdentifier = "CertificationCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let statusButton: FilterButton = {
        let button = FilterButton(type: .wait)
        button.isUserInteractionEnabled = false // 버튼처럼 보이지만 동작은 안 하게
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(statusButton)
        
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        statusButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-12)
            $0.height.equalTo(32)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configure(with certificationItem: CertificationItem) {
        imageView.loadImage(url: certificationItem.certificationMediaUrl)
        
        if let filterType = FilterTypes(status: certificationItem.status) {
            statusButton.update(type: filterType)
        }
    }
}
