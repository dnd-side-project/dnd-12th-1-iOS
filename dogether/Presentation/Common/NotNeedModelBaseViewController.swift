//
//  NotNeedModelBaseViewController.swift
//  dogether
//
//  Created by Jae hyung Kim on 3/12/25.
//

import UIKit

/// 모델이 필요하지 않는 BaseViewController
class NotNeedModelBaseViewController: UIViewController, BaseViewProtocol {
    
    override func loadView() {
        super.loadView()
        configureHierarchy()
        configureConstraints()
        configureView()
    }
    
    func configureHierarchy() {}
    
    func configureConstraints() {}
    
    func configureView() {}
}
