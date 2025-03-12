//
//  BaseView.swift
//  dogether
//
//  Created by 박지은 on 2/18/25.
//

import UIKit

protocol BaseViewProtocol {
    
    /// 뷰 계층을 구현하세요
    func configureHierarchy()
    
    /// 제약조건을 구현하세요
    func configureConstraints()
    
    /// UI를 정의하세요
    func configureView()
    
}

class BaseView: UIView, BaseViewProtocol {
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        configureHierarchy()
        configureConstraints()
        configureView()
    }
    
    func configureHierarchy() { }
    func configureConstraints() { }
    func configureView() { }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
