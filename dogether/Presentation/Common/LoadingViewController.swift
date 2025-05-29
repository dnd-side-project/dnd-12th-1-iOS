//
//  LoadingViewController.swift
//  dogether
//
//  Created by seungyooooong on 5/18/25.
//

import UIKit

final class LoadingViewController: BaseViewController {
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
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
        }
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white
        activityIndicator.startAnimating()
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        view.addSubview(activityIndicator)
    }

    override func configureConstraints() {
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
