//
//  DoneView.swift
//  dogether
//
//  Created by seungyooooong on 5/9/25.
//

import UIKit

final class DoneView: BaseView {
    init() { super.init(frame: .zero) }
    required init?(coder: NSCoder) { fatalError() }
    
    private let doneImageView = UIImageView(image: .highFiveDosik)
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "그룹 활동 기간이 모두 끝났어요 !"
        label.textColor = .grey0
        label.font = Fonts.head2B
        return label
    }()
    
    private let subTitleLabel = {
        let label = UILabel()
        label.text = "오늘이 지나면 이 페이지는 더 이상 열 수 없어요"
        label.textColor = .grey300
        label.font = Fonts.body2R
        return label
    }()
    
    private let doneStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    override func configureView() {
        [doneImageView, titleLabel, subTitleLabel].forEach { doneStackView.addArrangedSubview($0) }
        doneStackView.setCustomSpacing(16, after: doneImageView)
        doneStackView.setCustomSpacing(4, after: titleLabel)
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [doneStackView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        doneImageView.snp.makeConstraints {
            $0.width.equalTo(278)
            $0.height.equalTo(138)
        }
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(28)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.height.equalTo(21)
        }
        
        doneStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
