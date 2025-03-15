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
///     혹은 self.showPopup을 참고해주세요 ( 대리 함수 구성 완료 )
///
class BasePopUpViewController<V: UIView>: NotNeedModelBaseViewController {
    
    let popUpView: V
    
    private let backgroundView = UIView()
        .setOf {
            $0.backgroundColor = UIColor.grey900.withAlphaComponent(0)
        }
        
    private var horizontalPadding: CGFloat = 0
    
    private let backGroundDismissOption: Bool
    
    init(horizontalPadding: CGFloat, backGroundDismissOption: Bool = true) {
        self.popUpView = V()
        self.horizontalPadding = horizontalPadding
        self.backGroundDismissOption = backGroundDismissOption
        super.init(nibName: nil, bundle: nil)
        self.view.alpha = 0
        self.popUpView.alpha = 0
    }
    
    init(view: V, horizontalPadding: CGFloat = 0, backGroundDismissOption: Bool = true) {
        self.popUpView = view
        self.horizontalPadding = horizontalPadding
        self.backGroundDismissOption = backGroundDismissOption
        super.init(nibName: nil, bundle: nil)
        self.view.alpha = 0
        self.popUpView.alpha = 0
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
        self.view.addSubview(backgroundView)
        self.view.addSubview(popUpView)
    }
    
    override func configureConstraints() {
        
        self.backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.popUpView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(horizontalPadding)
            $0.center.equalToSuperview()
        }
    }
    
    override func configureView() {
        
        disMissCheckToAddAction()
    }
}



// MARK: USE
extension BasePopUpViewController {
    
    /// 좌우 패딩을 조절합니다.
    /// - Parameter horizontalPadding: 좌우 패딩 값
    func updateHorizontalPadding(_ horizontalPadding: CGFloat) {
        self.horizontalPadding = horizontalPadding
        self.popUpView.snp.remakeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(horizontalPadding)
            $0.center.equalToSuperview()
        }
    }
    
}

// MARK: VIEW EFFECT
extension BasePopUpViewController {
    
    /// 뷰가 사라질때의 애니메이션을 정의합니다.
    private func dismissAct() {
        view.alpha = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) { [weak self] in
            guard let weakSelf = self else { return }
            UIView.animate(withDuration: 0.3) {
                weakSelf.popUpView.backgroundColor = UIColor.black.withAlphaComponent(0)
                weakSelf.backgroundView.backgroundColor = UIColor.grey900.withAlphaComponent(0)
                weakSelf.view.alpha = 0
            } completion: { _ in
                weakSelf.dismiss(animated: false)
            }
        }
    }
    
    /// 팝업 노출 효과를 정의합니다.
    private func showAct() {
        backgroundView.backgroundColor = UIColor.grey900.withAlphaComponent(0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) { [weak self] in
            guard let weakSelf = self else { return }
            UIView.animate(withDuration: 0.4) {
                weakSelf.backgroundView.backgroundColor = UIColor.grey900.withAlphaComponent(0.8)
                weakSelf.view.alpha = 1
                weakSelf.popUpView.alpha = 1
            }
        }
    }
    
    private func disMissCheckToAddAction() {
        if backGroundDismissOption {
            backgroundView
                .addTapGesture { [weak self] in
                    guard let self else { return }
                    dismissAct()
                }
        }
    }
}

#if DEBUG
final class ExamplePopupViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 버튼 눌렀다 가정
        let popUpView = CertificationInfoPopupView(todoInfo: TodoInfo(
            id: 0,
            content: "CENTER",
            status: "STATUS"
        )) {
            logger.debug("무언가 함.")
        }
        
        // 혹은
        self.showPopUp(view: popUpView) { view in
            view.backgroundColor = .red
            view.dismissButtonTapped()
            // ..Etc
        }
        
//        // 다음과 같이 단 init() 전용 매개변수가 필요시 위 방식으로 대체 하시오
//        self.showPopUp(type: CertificationInfoPopupView.self) { view in
//            view.backgroundColor = .green
//        }
    }
    
}
#endif
