//
//  LoadingPage.swift
//  dogether
//
//  Created by seungyooooong on 12/29/25.
//

import UIKit

import Lottie

final class LoadingPage: BasePage {
    private let backgroundView = UIView()
    private let animationView = LottieAnimationView(name: "dogetherLoading")
    
    private var currentIsShowLoading: Bool?
    
    override func configureView() {
        isHidden = true
        isUserInteractionEnabled = true
        
        backgroundView.backgroundColor = .grey900.withAlphaComponent(0.8)
        
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [backgroundView, animationView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        backgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-UIApplication.safeAreaOffset.top)
            $0.bottom.equalToSuperview().offset(UIApplication.safeAreaOffset.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
        animationView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(120)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? LoadingViewDatas {
            if currentIsShowLoading != datas.isShowLoading {
                currentIsShowLoading = datas.isShowLoading
                
                isHidden = !datas.isShowLoading
                
                if datas.isShowLoading { animationView.play() }
                else { animationView.stop() }
            }
        }
    }
}
