//
//  ErrorViewController.swift
//  dogether
//
//  Created by seungyooooong on 12/17/25.
//

import Foundation

final class ErrorViewController: BaseViewController {
    private let errorPage = ErrorPage()
    private let viewModel = ErrorViewModel()
    
    // FIXME: 추후 수정
    var completions: [(() -> Void)] = []
    
    override func viewDidLoad() {
        errorPage.delegate = self
        
        pages = [errorPage]

        super.viewDidLoad()
    }
    
    override func setViewDatas() {
        bind(viewModel.buttonViewDatas)
    }
}

protocol ErrorDelegate {
    func retryAction()
}

extension ErrorViewController: ErrorDelegate {
    func retryAction() {
        coordinator?.dismissErrorView() { [weak self] in
            guard let self else { return }
            while let completion = completions.popLast() { completion() }
        }
    }
}
