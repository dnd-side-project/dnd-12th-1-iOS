//
//  BasePopUpViewController.swift
//  dogether
//
//  Created by Jae hyung Kim on 3/6/25.
//

import UIKit.UIViewController
import SnapKit

/// 팝업뷰 베이스 뷰 컨트롤러 입니다.
///
/// 사용법은 다음과 같습니다.
///
///     사용할 뷰의 타입을 정하는 ViewController 를 선언합니다.
///     final class ExamplePopUpViewController: BasePopUpViewController<EmptyView> {
///         추가적 동작
///     }
///     ...
///
///     examplePopUpViewController.popUpView.~~Action 접근 가능
///
class BasePopUpViewController<V: UIView>: NotNeedModelBaseViewController {
    
    let popUpView = V()
    private var horizontalPadding: CGFloat = 0
    
    init(horizontalPadding: CGFloat) {
        self.horizontalPadding = horizontalPadding
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        logger.error("no USE StoryBoard \(#file)")
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAct()
    }
    
    override func configureHierarchy() {
        self.view.addSubview(popUpView)
    }
    
    override func configureConstraints() {
        self.popUpView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(horizontalPadding)
        }
    }
    
    override func configureView() {}
    
}
// MARK: USE
extension BasePopUpViewController {
    
    /// 좌우 패딩을 조절합니다.
    /// - Parameter horizontalPadding: 좌우 패딩 값
    func updateHorizontalPadding(_ horizontalPadding: CGFloat) {
        self.horizontalPadding = horizontalPadding
        self.popUpView.snp.remakeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(horizontalPadding)
        }
    }
    
}

// MARK: VIEW EFFECT
extension BasePopUpViewController {
    
    /// 뷰가 사라질때의 애니메이션을 정의합니다.
    ///
    /// 직접 호출하셔야 합니다.
    func dismissAct() {
        view.alpha = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) { [weak self] in
            guard let weakSelf = self else { return }
            UIView.animate(withDuration: 0.3) {
                weakSelf.popUpView.backgroundColor = UIColor.black.withAlphaComponent(0)
                weakSelf.view.alpha = 0
            } completion: { _ in
                weakSelf.dismiss(animated: false)
            }
        }
    }
    
    /// 팝업 노출 효과를 정의합니다.
    private func showAct() {
        view.alpha = 0
        popUpView.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) { [weak self] in
            guard let weakSelf = self else { return }
            UIView.animate(withDuration: 0.4) {
                weakSelf.popUpView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                weakSelf.view.alpha = 1
                weakSelf.popUpView.alpha = 1
            }
        }
    }
}
