//
//  TodayEmptyView.swift
//  dogether
//
//  Created by seungyooooong on 5/9/25.
//

import UIKit

final class TodayEmptyView: BaseView {
    var delegate: MainDelegate? {
        didSet {
            todoButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.goWriteTodoViewAction(todos: [])
                }, for: .touchUpInside
            )
        }
    }
    
    private let emptyImageView = UIImageView(image: .todo)
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let emptyStackView = UIStackView()
    private let todoButton = DogetherButton("투두 작성하기")
    
    override func configureView() {
        titleLabel.text = "오늘의 투두를 작성해보세요"
        titleLabel.textColor = .grey0
        titleLabel.font = Fonts.head2B
        
        subTitleLabel.text = "매일 자정부터 새로운 투두를 입력해요"
        subTitleLabel.textColor = .grey300
        subTitleLabel.font = Fonts.body2R
        
        emptyStackView.axis = .vertical
        emptyStackView.alignment = .center
        
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
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        
        // FIXME: 추후 수정
        let dogetherButtonViewDatas = todoButton.currentViewDatas ?? DogetherButtonViewDatas()
        todoButton.updateView(dogetherButtonViewDatas)
    }
}
