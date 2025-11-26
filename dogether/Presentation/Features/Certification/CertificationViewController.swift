//
//  CertificationViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/16/25.
//

import UIKit

final class CertificationViewController: BaseViewController {
    private let certificationPage = CertificationPage()
    private let viewModel = CertificationViewModel()
    
    override func viewDidLoad() {
        certificationPage.delegate = self
        
        pages = [certificationPage]

        super.viewDidLoad()
        
        onAppear()
    }
    
    override func setViewDatas() {
        if let datas = datas as? CertificationViewDatas {
            viewModel.certificationViewDatas.accept(datas)
        }
        
        bind(viewModel.certificationViewDatas)
    }
}

// MARK: - delegate
protocol CertificationDelegate {
    func thumbnailTapAction(_ stackView: UIStackView, _ gesture: UITapGestureRecognizer)
    func certificationTapAction(_ scrollView: UIScrollView, _ stackView: UIStackView, _ gesture: UITapGestureRecognizer)
    func certificationListScrollEndAction(index: Int)
    func goCertificateViewAction(todo: TodoEntity)
}

extension CertificationViewController: CertificationDelegate {
    private func onAppear() {
        Task { [weak self] in
            guard let self else { return }
            try await viewModel.readTodo()
        }
    }
    
    func thumbnailTapAction(_ stackView: UIStackView, _ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: stackView)

        for (index, view) in stackView.arrangedSubviews.enumerated() {
            if view.frame.contains(location) {
                Task { [weak self] in
                    guard let self else { return }
                    try await viewModel.setIndex(index: index)
                }
                return
            }
        }
    }
    
    func certificationTapAction(
        _ scrollView: UIScrollView,
        _ stackView: UIStackView,
        _ gesture: UITapGestureRecognizer
    ) {
        let location = gesture.location(in: scrollView)
        let scrollViewWidth = scrollView.bounds.width
        
        // MARK: view 중앙을 기준으로 direction 결정
        let direction: Directions = location.x - scrollView.contentOffset.x < scrollViewWidth / 2 ? .prev : .next
        let index = Int(round(scrollView.contentOffset.x / scrollViewWidth))
        let nextIndex = index + direction.tag
        
        if nextIndex < 0 || stackView.arrangedSubviews.count <= nextIndex { return }
        
        let newOffset = CGPoint(x: scrollViewWidth * CGFloat(nextIndex), y: 0)
        UIView.animate(withDuration: 0.3, animations: {
            scrollView.setContentOffset(newOffset, animated: false)
        }, completion: { [weak self] finished in
            guard let self else { return }
            if finished { Task { try await self.viewModel.setIndex(index: nextIndex) } }
        })
    }
    
    func certificationListScrollEndAction(index: Int) {
        Task { [weak self] in
            guard let self else { return }
            try await viewModel.setIndex(index: index)
        }
    }
    
    func goCertificateViewAction(todo: TodoEntity) {
        let certificateImageViewController = CertificateImageViewController()
        certificateImageViewController.viewModel.todoInfo = todo
        coordinator?.pushViewController(certificateImageViewController)
    }
}
