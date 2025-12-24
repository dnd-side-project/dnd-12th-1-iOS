//
//  ProfileView.swift
//  dogether
//
//  Created by seungyooooong on 11/27/25.
//

import UIKit

final class ProfileView: BaseStackView {
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    
    private var currentName: String?
    private var currentImageUrl: String?
    
    override func configureView() {
        axis = .horizontal
        spacing = 20
        
        profileImageView.image = .profile
        profileImageView.contentMode = .scaleAspectFit
        
        nameLabel.textColor = .grey0
        nameLabel.font = Fonts.head2B
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [profileImageView, nameLabel].forEach { addArrangedSubview($0) }
    }
    
    override func configureConstraints() {
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(48)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? ProfileViewDatas {
            if currentName != datas.name {
                currentName = datas.name
                nameLabel.text = datas.name
            }
            
            if currentImageUrl != datas.imageUrl {
                currentImageUrl = datas.imageUrl
                profileImageView.loadImage(url: datas.imageUrl)
            }
        }
    }
}
