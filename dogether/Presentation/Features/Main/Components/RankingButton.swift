//
//  RankingButton.swift
//  dogether
//
//  Created by seungyooooong on 9/29/25.
//

import UIKit

final class RankingButton: BaseButton {
    var delegate: MainDelegate? {
        didSet {
            addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.goRankingViewAction()
                }, for: .touchUpInside
            )
        }
    }
    
    private let chartImageView = UIImageView(image: .chart)
    private let label = UILabel()
    private let chevronImageView = UIImageView()
    
    private(set) var currentAlpha: CGFloat?
    
    override func configureView() {
        backgroundColor = .grey700
        layer.cornerRadius = 8
        
        chartImageView.isUserInteractionEnabled = false
        
        label.text = "그룹 활동 한눈에 보기 !"
        label.textColor = .grey200
        label.font = Fonts.body1S
        label.isUserInteractionEnabled = false
        
        chevronImageView.image = .chevronRight.withRenderingMode(.alwaysTemplate)
        chevronImageView.tintColor = .grey200
        chevronImageView.isUserInteractionEnabled = false
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [chartImageView, label, chevronImageView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        chartImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.width.height.equalTo(24)
        }
        
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(chartImageView.snp.right).offset(8)
            $0.height.equalTo(25)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-16)
            $0.width.height.equalTo(24)
        }
    }
    
    override func updateView(_ data: any BaseEntity) {
        if let datas = data as? SheetViewDatas {
            if currentAlpha == datas.alpha { return }
            currentAlpha = datas.alpha
            
            alpha = datas.alpha
        }
    }
}
