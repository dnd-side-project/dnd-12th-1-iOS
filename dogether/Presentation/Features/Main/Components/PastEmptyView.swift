//
//  PastEmptyView.swift
//  dogether
//
//  Created by seungyooooong on 5/9/25.
//

import UIKit

final class PastEmptyView: BaseView {
    init() { super.init(frame: .zero) }
    required init?(coder: NSCoder) { fatalError() }
    
    private let emptyImageView = UIImageView(image: .embarrassedDosik)
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "해당 날짜에 작성된 투두가 없어요"
        label.textColor = .grey200
        label.font = Fonts.head2B
        return label
    }()
    
    private let subTitleLabel = {
        let label = UILabel()
        label.text = "과거 날짜에서는 새로운 투두를 작성할 수 없어요"
        label.textColor = .grey400
        label.font = Fonts.body2R
        return label
    }()
    
    private let emptyStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    override func configureView() {
        [emptyImageView, titleLabel, subTitleLabel].forEach { emptyStackView.addArrangedSubview($0) }
        emptyStackView.setCustomSpacing(10, after: emptyImageView)
        emptyStackView.setCustomSpacing(4, after: titleLabel)
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [emptyStackView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        emptyImageView.snp.makeConstraints {
            $0.width.height.equalTo(150)
        }
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(28)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.height.equalTo(21)
        }
        
        emptyStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
