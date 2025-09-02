//
//  SplashPage.swift
//  dogether
//
//  Created by 승용 on 7/31/25.
//

import UIKit

final class SplashPage: BasePage {
    private let logoImageView = UIImageView()
    private let typoImageView = UIImageView()
    private let logoStackView = UIStackView()
    
    override func configureView() {
        logoImageView.image = .logo
        logoImageView.contentMode = .scaleAspectFit
        
        typoImageView.image = .logoTypo
        typoImageView.contentMode = .scaleAspectFit
        
        [logoImageView, typoImageView].forEach { logoStackView.addArrangedSubview($0) }
        logoStackView.axis = .vertical
        logoStackView.spacing = 24
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [logoStackView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        logoImageView.snp.makeConstraints {
            $0.height.equalTo(82)
        }
        
        typoImageView.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        logoStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
