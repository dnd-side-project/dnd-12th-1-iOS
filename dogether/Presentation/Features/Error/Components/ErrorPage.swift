//
//  ErrorPage.swift
//  dogether
//
//  Created by seungyooooong on 12/17/25.
//

import UIKit

final class ErrorPage: BasePage {
    var delegate: ErrorDelegate? {
        didSet {
            retryButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.retryAction()
                }, for: .touchUpInside
            )
        }
    }
    
    private let imageView = UIImageView(image: .iceDosik)
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let retryButton = DogetherButton("다시 시도")
    private let stackView = UIStackView()
    
    override func configureView() {
        titleLabel.text = "서비스 이용이 원활하지 않아요"
        titleLabel.textColor = .grey200
        titleLabel.font = Fonts.head2B
        
        descriptionLabel.text = "잠시 후 다시 접속해주세요."
        descriptionLabel.textColor = .grey400
        descriptionLabel.font = Fonts.body2R
        
        stackView.axis = .vertical
        stackView.alignment = .center
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [imageView, titleLabel, descriptionLabel, retryButton].forEach { stackView.addArrangedSubview($0) }
        stackView.setCustomSpacing(16, after: imageView)
        stackView.setCustomSpacing(20, after: descriptionLabel)
        
        addSubview(stackView)
    }
    
    override func configureConstraints() {
        imageView.snp.makeConstraints {
            $0.size.equalTo(200)
        }
        
        retryButton.snp.makeConstraints {
            $0.width.equalTo(160)
        }
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? DogetherButtonViewDatas {
            retryButton.updateView(datas)
        }
    }
}
