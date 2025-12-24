//
//  LoadingViewController.swift
//  dogether
//
//  Created by seungyooooong on 5/18/25.
//

import UIKit

import Lottie

final class LoadingViewController: BaseViewController {
    private let animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "dogetherLoading")
        view.loopMode = .loop
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        view.isHidden = true
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        Task { [weak self] in
            guard let self else { return }
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            view.isHidden = false
            animationView.play()
        }
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        view.addSubview(animationView)
    }
    
    override func configureConstraints() {
        animationView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(120) 
        }
    }
}
