//
//  SplashViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/15/25.
//

import UIKit
import SnapKit

final class SplashViewController: BaseViewController {
    private let viewModel = SplashViewModel()
    
    private let logoView: UIStackView = {
        let logoImage = UIImageView(image: .logo)
        logoImage.contentMode = .scaleAspectFit
        
        let typoImage = UIImageView(image: .logoTypo)
        typoImage.contentMode = .scaleAspectFit
        
        let stackView = UIStackView(arrangedSubviews: [logoImage, typoImage])
        stackView.axis = .vertical
        stackView.spacing = 24
        
        logoImage.snp.makeConstraints {
            $0.height.equalTo(82)
        }
        
        typoImage.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            try await viewModel.launchApp()
            let destination = try await viewModel.getDestination()
            await MainActor.run {
                coordinator?.setNavigationController(destination)
            }
        }
    }
    
    override func configureView() { }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [logoView].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        logoView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
