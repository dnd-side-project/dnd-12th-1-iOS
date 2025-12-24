//
//  PopupPage.swift
//  dogether
//
//  Created by seungyooooong on 12/7/25.
//

import Foundation

final class PopupPage: BasePage {
    var delegate: PopupDelegate? {
        didSet {
            alertStackView.delegate = delegate
            examinateStackView.delegate = delegate
        }
    }
    
    private let alertStackView = AlertStackView()
    private let examinateStackView = ExaminateStackView()
    
    override func configureView() {
        backgroundColor = .grey700
        layer.cornerRadius = 12
    }
    
    override func configureAction() { addTapAction { _ in return } }
    
    override func configureHierarchy() {
        [alertStackView, examinateStackView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        [alertStackView, examinateStackView].forEach { stackView in
            stackView.snp.makeConstraints {
                $0.verticalEdges.equalToSuperview().inset(24)
                $0.horizontalEdges.equalToSuperview().inset(20)
            }
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? AlertPopupViewDatas {
            if subviews.contains(examinateStackView) {
                examinateStackView.removeFromSuperview()
            }
            
            alertStackView.updateView(datas)
        }
        
        if let datas = data as? ExaminatePopupViewDatas {
            if subviews.contains(alertStackView) {
                alertStackView.removeFromSuperview()
            }
            
            examinateStackView.updateView(datas)
        }
        
        if let datas = data as? DogetherTextViewDatas {
            examinateStackView.updateView(datas)
            
            if datas.isShowKeyboard {
                addTapAction { [weak self] _ in
                    guard let self else { return }
                    examinateStackView.endEditing(true)
                }
            } else { addTapAction { _ in return } }
        }
        
        if let datas = data as? DogetherButtonViewDatas {
            examinateStackView.updateView(datas)
        }
    }
}
