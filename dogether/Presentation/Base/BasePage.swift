//
//  BasePage.swift
//  dogether
//
//  Created by 승용 on 7/31/25.
//

import UIKit

class BasePage: UIView {
    var coordinatorDelegate: CoordinatorDelegate?
    
    /// 상위 뷰 컨트롤러의 viewDidLoad에서 호출됩니다
    func pageDidLoad() {
        configureView()
        configureAction()
        configureHierarchy()
        configureConstraints()
    }
    
    /// 뷰의 시각적인 속성을 설정하는 역할을 합니다
    func configureView() { }
    
    /// 뷰의 동작 및 이벤트 처리를 설정하는 역할을 합니다
    func configureAction() { }
    
    /// 뷰 계층을 구성하는 역할을 합니다
    func configureHierarchy() { }
    
    /// SnapKit을 이용해 레이아웃을 설정하는 역할을 합니다
    func configureConstraints() { }
    
    /// 뷰의 가변 요소들을 업데이트하는 역할을 합니다
    func updateView(_ data: any BaseEntity) { }
}
