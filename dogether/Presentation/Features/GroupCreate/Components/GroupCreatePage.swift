//
//  GroupCreatePage.swift
//  dogether
//
//  Created by seungyooooong on 11/10/25.
//

import UIKit
import SnapKit

final class GroupCreatePage: BasePage {
    var delegate: GroupCreateDelegate? {
        didSet {
            stepButtonStackView.delegate = delegate
            stepOneView.delegate = delegate
            stepTwoView.delegate = delegate
        }
    }
    
    private let navigationHeader = NavigationHeader(title: "그룹 만들기")
    private let stepInfoStackView = StepInfoStackView()
    private let stepButtonStackView = StepButtonStackView()
    
    private var stepOneView = StepOneView()
    private var stepTwoView = StepTwoView()
    private var stepThreeView = StepThreeView()
    
    override func configureView() { }
    
    override func configureAction() {
        addTapAction { [weak self] _ in
            guard let self else { return }
            endEditing(true)
        }

        navigationHeader.delegate = coordinatorDelegate
    }
    
    override func configureHierarchy() {
        [ navigationHeader, stepInfoStackView, stepButtonStackView,
          stepOneView, stepTwoView, stepThreeView
        ].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        stepInfoStackView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        stepButtonStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        stepOneView.snp.makeConstraints {
            $0.top.equalTo(stepInfoStackView.snp.bottom).offset(40)
            $0.bottom.equalTo(stepButtonStackView.snp.top)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        stepTwoView.snp.makeConstraints {
            $0.top.equalTo(stepInfoStackView.snp.bottom).offset(40)
            $0.bottom.equalTo(stepButtonStackView.snp.top)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        stepThreeView.snp.makeConstraints {
            $0.top.equalTo(stepInfoStackView.snp.bottom).offset(84)
            $0.bottom.equalTo(stepButtonStackView.snp.top)
            $0.horizontalEdges.equalToSuperview().inset(36)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? GroupCreateViewDatas {
            stepInfoStackView.updateView(datas)
            
            stepButtonStackView.updateView(datas)
            
            stepOneView.isHidden = datas.step != .one
            stepTwoView.isHidden = datas.step != .two
            stepThreeView.isHidden = datas.step != .three
            
            switch datas.step {
            case .one:
                stepOneView.updateView(datas)
            case .two:
                stepTwoView.updateView(datas)
                endEditing(true)
            case .three:
                stepThreeView.updateView(datas)
            }
        }
    }
}
