//
//  ThumbnailListView.swift
//  dogether
//
//  Created by seungyooooong on 10/21/25.
//

import UIKit

final class ThumbnailListView: BaseView {
    var delegate: CertificationDelegate? {
        didSet {
            stackView.addTapAction { [weak self] gesture in
                guard let self else { return }
                delegate?.thumbnailTapAction(stackView, gesture)
            }
        }
    }
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    private var isFirst: Bool = true
    private var currentIndex: Int?
    
    override func configureView() {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [scrollView].forEach { addSubview($0) }
        [stackView].forEach { scrollView.addSubview($0) }
    }
    
    override func configureConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? CertificationViewDatas {
            if isFirst {
                isFirst = false
                
                datas.todos
                    .enumerated().map {
                        let thumbnailView = ThumbnailView()
                        let thumbnailViewDatas = ThumbnailViewDatas(
                            imageUrl: $1.certificationMediaUrl,
                            thumbnailStatus: $1.thumbnailStatus,
                            isHighlighted: $0 == datas.index
                        )
                        thumbnailView.updateView(thumbnailViewDatas)
                        return thumbnailView
                    }
                    .forEach {
                        stackView.addArrangedSubview($0)
                    }
            }
            
            if currentIndex != datas.index {
                currentIndex = datas.index
                
                layoutIfNeeded()
                
                stackView.arrangedSubviews.enumerated().forEach {
                    guard let thumbnailView = $1 as? ThumbnailView else { return }
                    let thumbnailViewDatas = ThumbnailViewDatas(
                        imageUrl: datas.todos[$0].certificationMediaUrl,
                        thumbnailStatus: datas.todos[$0].thumbnailStatus,
                        isHighlighted: $0 == datas.index
                    )
                    thumbnailView.updateView(thumbnailViewDatas)
                    
                    if $0 == datas.index {
                        let scrollViewWidth = scrollView.bounds.width
                        let idealOffset = $1.frame.midX - scrollViewWidth / 2 + 16
                        let newOffset = max(0, min(idealOffset, scrollView.contentSize.width - scrollViewWidth))
                        scrollView.setContentOffset(CGPoint(x: newOffset, y: 0), animated: true)
                    }
                }
            }
        }
    }
}
