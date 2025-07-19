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
    
    private let updateContainer: UIView = UIView()
    
    private let updateStackView: UIStackView = {
        let typoImage = UIImageView(image: .logoTypo)
        typoImage.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.text = "두게더가 새로워졌어요!"
        titleLabel.textColor = .grey0
        titleLabel.font = Fonts.head1B
        
        let descriptionLabel = UILabel()
        descriptionLabel.attributedText = NSAttributedString(
            string: "두게더가 유저분들의 의견을 반영하여\n더 편하게 사용하도록 사용성을 개선했어요.\n지금 바로 업데이트하고 인증하러 가요!",
            attributes: Fonts.getAttributes(for: Fonts.body1R, textAlignment: .center)
        )
        descriptionLabel.textColor = .grey200
        descriptionLabel.numberOfLines = 0
        
        let updateImage = UIImageView(image: .partyDosik)
        
        let stackView = UIStackView(arrangedSubviews: [typoImage, titleLabel, descriptionLabel, updateImage])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        
        stackView.setCustomSpacing(40, after: typoImage)
        stackView.setCustomSpacing(8, after: titleLabel)
        stackView.setCustomSpacing(44, after: descriptionLabel)
        
        typoImage.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(36)
        }
        
        updateImage.snp.makeConstraints {
            guard let image = updateImage.image else { return }
            let aspectRatio = image.size.height / image.size.width
            
            $0.width.equalToSuperview()
            $0.height.equalTo(updateImage.snp.width).multipliedBy(aspectRatio)
        }
        
        return stackView
    }()
    
    private let updateButton: UIButton = DogetherButton(title: "업데이트 하러가기")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            try await viewModel.launchApp()
            try await viewModel.checkUpdate()
            if viewModel.needUpdate {
                updateView()
            } else {
                let destination = try await viewModel.getDestination()
                await MainActor.run {
                    coordinator?.setNavigationController(destination)
                }
            }
        }
    }
    
    override func configureView() {
        updateView()
    }
    
    override func configureAction() {
        updateButton.addAction(
            UIAction { _ in
                SystemManager().openAppStore()
            }, for: .touchUpInside
        )
    }
    
    override func configureHierarchy() {
        [logoView, updateContainer, updateButton].forEach { view.addSubview($0) }
        [updateStackView].forEach { updateContainer.addSubview($0) }
    }
    
    override func configureConstraints() {
        logoView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        updateContainer.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(updateButton.snp.top)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        updateStackView.snp.makeConstraints {
            $0.center.width.equalToSuperview()
        }
        
        updateButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}

extension SplashViewController {
    func updateView() {
        logoView.isHidden = viewModel.needUpdate
        updateContainer.isHidden = !viewModel.needUpdate
        updateButton.isHidden = !viewModel.needUpdate
    }
}
