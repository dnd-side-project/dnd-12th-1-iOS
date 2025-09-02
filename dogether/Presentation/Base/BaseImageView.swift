//
//  BaseImageView.swift
//  dogether
//
//  Created by seungyooooong on 4/9/25.
//

import UIKit

class BaseImageView: UIImageView {
    override init(image: UIImage? = nil) {
        super.init(image: image)
        
        configureView()
        configureAction()
        configureHierarchy()
        configureConstraints()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    /// 뷰의 시각적인 속성을 설정하는 역할을 합니다
    func configureView() { }
    
    /// 뷰의 동작 및 이벤트 처리를 설정하는 역할을 합니다
    func configureAction() { }
    
    /// 뷰 계층을 구성하는 역할을 합니다
    func configureHierarchy() { }
    
    /// SnapKit을 이용해 레이아웃을 설정하는 역할을 합니다
    func configureConstraints() { }
}
