//
//  StepButtonStackView.swift
//  dogether
//
//  Created by seungyooooong on 11/12/25.
//

import UIKit

final class StepButtonStackView: BaseStackView {
    var delegate: GroupCreateDelegate? {
        didSet {
            [prevButton, nextButton].forEach { button in
                button.addAction(
                    UIAction { [weak self] _ in
                        guard let self, let currentStep else { return }
                        delegate?.updateStep(step: CreateGroupSteps(rawValue: currentStep.rawValue + button.tag))
                    }, for: .touchUpInside
                )
            }
            createButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.createGroup()
                }, for: .touchUpInside
            )
        }
    }
    
    // FIXME: 추후 수정
    private let prevButton = UIButton()
    private let nextButton = DogetherButton("다음")
    private let createButton = DogetherButton("그룹 생성")
    
    private var currentStep: CreateGroupSteps?
    private var currentGroupName: String?
    
    override func configureView() {
        axis = .horizontal
        spacing = 8
        distribution = .fillEqually
        
        prevButton.setTitle("이전", for: .normal)
        prevButton.setTitleColor(.grey200, for: .normal)
        prevButton.backgroundColor = .grey500
        prevButton.titleLabel?.font = Fonts.body1B
        prevButton.layer.cornerRadius = 8
        prevButton.tag = Directions.prev.tag
        
        nextButton.tag = Directions.next.tag
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() { }
    
    override func configureConstraints() { }
    
    // MARK: - updateView
    override func updateView(_ data: any BaseEntity) {
        if let datas = data as? GroupCreateViewDatas {
            if currentStep != datas.step {
                currentStep = datas.step
                
                prevButton.isHidden = datas.step == .one
                nextButton.isHidden = datas.step == .three
                createButton.isHidden = datas.step != .three
                
                arrangedSubviews.forEach { removeArrangedSubview($0) }
                switch datas.step {
                case .one:
                    [nextButton].forEach { addArrangedSubview($0) }
                case .two:
                    [prevButton, nextButton].forEach { addArrangedSubview($0) }
                case .three:
                    [prevButton, createButton].forEach { addArrangedSubview($0) }
                    
                    // FIXME: 추후 수정
                    let dogetherButtonViewDatas = createButton.currentViewDatas ?? DogetherButtonViewDatas()
                    createButton.updateView(dogetherButtonViewDatas)
                }
            }
            
            if currentGroupName != datas.groupName {
                currentGroupName = datas.groupName
                
                // FIXME: 추후 수정
                var nextButtonViewDatas = nextButton.currentViewDatas ?? DogetherButtonViewDatas(status: .disabled)
                nextButtonViewDatas.status = datas.groupName.count > 0 ? .enabled : .disabled
                nextButton.updateView(nextButtonViewDatas)
            }
        }
    }
}
