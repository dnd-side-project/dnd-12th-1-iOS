//
//  TodayEmptyView.swift
//  dogether
//
//  Created by seungyooooong on 5/9/25.
//

import UIKit

final class TodayEmptyView: BaseView {
    init() { super.init(frame: .zero) }
    required init?(coder: NSCoder) { fatalError() }
    
    private let emptyImageView = UIImageView(image: .todo)
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "오늘의 투두를 작성해보세요"
        label.textColor = .grey0
        label.font = Fonts.head2B
        return label
    }()
    
    private let subTitleLabel = {
        let label = UILabel()
        label.text = "매일 자정부터 새로운 투두를 입력해요"
        label.textColor = .grey300
        label.font = Fonts.body2R
        return label
    }()
    
    private let emptyStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    var todoButton = DogetherButton(title: "투두 작성하기", status: .enabled)
    
    override func configureView() {
        [emptyImageView, titleLabel, subTitleLabel].forEach { emptyStackView.addArrangedSubview($0) }
        emptyStackView.setCustomSpacing(10, after: emptyImageView)
        emptyStackView.setCustomSpacing(4, after: titleLabel)
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [emptyStackView, todoButton].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        emptyImageView.snp.makeConstraints {
            $0.width.equalTo(202)
            $0.height.equalTo(131)
        }
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(28)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.height.equalTo(21)
        }
        
        emptyStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-(16 + 50) / 2)
        }
        
        todoButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
