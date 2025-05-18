//
//  StatsEmptyView.swift
//  dogether
//
//  Created by yujaehong on 4/23/25.
//

import UIKit

final class StatsEmptyView: BaseView {
    private let emptyStateView = EmptyStateView(
        title: "소속된 그룹이 없어요",
        description: "새로운 그룹을 만들어 함께 시작해보세요!"
    )
    
    private let createGroupButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue300
        button.layer.cornerRadius = 12
        button.setTitle("그룹 만들기", for: .normal)
        button.setTitleColor(.grey800, for: .normal)
        button.titleLabel?.font = Fonts.body1B
        return button
    }()
    
    var createButtonTapHandler: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) { fatalError() }
    
    override func configureView() {
        backgroundColor = .clear
    }
    
    override func configureAction() {
        createGroupButton.addAction(
            UIAction { [weak self] _ in
                self?.createButtonTapHandler?()
            },
            for: .touchUpInside
        )
    }
    
    override func configureHierarchy() {
        addSubview(emptyStateView)
        addSubview(createGroupButton)
    }
    
    override func configureConstraints() {
        emptyStateView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(160)
            $0.centerX.equalToSuperview()
        }
        
        createGroupButton.snp.makeConstraints {
            $0.top.equalTo(emptyStateView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(160)
            $0.height.equalTo(50)
        }
    }
}
