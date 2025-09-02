//
//  StartViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/9/25.
//

import UIKit

import RxSwift
import RxCocoa

final class StartViewController: BaseViewController {
    private let startPage = StartPage()
    private let viewModel = StartViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        startPage.delegate = self
        
        pages = [startPage]
        
        super.viewDidLoad()
    }
    
    override func setViewDatas() {
        guard let datas = datas as? StartViewDatas else { return }
        viewModel.startViewDatas.accept(datas)
    }
    
    override func bindViewModel() {
        viewModel.startViewDatas
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: StartViewDatas())
            .drive(onNext: { [weak self] datas in
                guard let self else { return }
                startPage.viewDidUpdate(datas)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - delegate
protocol StartDelegate {
    func startAction(_ destination: BaseViewController)
}

extension StartViewController: StartDelegate {
    func startAction(_ destination: BaseViewController) {
        coordinator?.pushViewController(destination)
    }
}
