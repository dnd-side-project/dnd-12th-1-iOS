//
//  DogetherHeader.swift
//  dogether
//
//  Created by seungyooooong on 2/9/25.
//

import UIKit
import SnapKit

final class DogetherHeader: BaseView {
    weak var delegate: CoordinatorDelegate? {
        didSet {
            myPageButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.coordinator?.pushViewController(MyPageViewController())
                }, for: .touchUpInside
            )
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let dogetherIconTypo = {
        let imageView = UIImageView()
        imageView.image = .logoTypo.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .grey0
        return imageView
    }()
    
    private let myPageButton = {
        let button = UIButton()
        button.setImage(.myPage.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .grey0
        return button
    }()
    
    override func configureView() { }
    
    override func configureAction() { }
     
    override func configureHierarchy() {
        [dogetherIconTypo, myPageButton].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        self.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        dogetherIconTypo.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
            $0.width.equalTo(91)
            $0.height.equalTo(20)
        }
        
        myPageButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(16)
            $0.width.height.equalTo(24)
        }
    }
}
