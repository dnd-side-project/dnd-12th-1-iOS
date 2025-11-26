//
//  BaseViewController.swift
//  dogether
//
//  Created by 박지은 on 2/9/25.
//

import UIKit

import RxSwift
import RxCocoa

class BaseViewController: UIViewController, CoordinatorDelegate {
    weak var coordinator: NavigationCoordinator?
    var datas: (any BaseEntity)?
    var pages: Array<BasePage>?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .grey900
        
        // FIXME: 추후 삭제
        configureView()
        configureAction()
        configureHierarchy()
        configureConstraints()
        
        guard let pages else { return }
        configurePages(pages)
        
        setViewDatas()
    }
    
    /// 뷰의 시각적인 속성을 설정하는 역할을 합니다
    func configureView() { }
    
    /// 뷰의 동작 및 이벤트 처리를 설정하는 역할을 합니다
    func configureAction() { }
    
    /// 뷰 계층을 구성하는 역할을 합니다
    func configureHierarchy() { }
    
    /// SnapKit을 이용해 레이아웃을 설정하는 역할을 합니다
    func configureConstraints() { }
    
    /// UI를 구성할 페이지들을 설정하는 역할을 합니다
    func configurePages(_ pages: [BasePage]) {
        pages.forEach { page in
            page.coordinatorDelegate = self
            page.frame = view.frame
            
            view.addSubview(page)
            page.snp.makeConstraints {
                $0.edges.equalTo(view.safeAreaLayoutGuide)
            }
            
            page.pageDidLoad()
        }
    }
    
    /// View를 구성하는 필수 데이터를 세팅하고 바인딩하는 역할을 합니다
    func setViewDatas() { }
    
    /// ViewDatas의 변화에 Page가 update 되도록 바인딩하는 역할을 합니다
    func bind<Entity: BaseEntity>(_ relay: BehaviorRelay<Entity>) {
        relay
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: relay.value)
            .drive(onNext: { [weak self] datas in
                guard let self, let pages else { return }
                pages.forEach { $0.updateView(datas) }
            })
            .disposed(by: disposeBag)
    }
}
