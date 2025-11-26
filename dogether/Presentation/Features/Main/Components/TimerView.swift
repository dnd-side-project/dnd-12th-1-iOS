//
//  TimerView.swift
//  dogether
//
//  Created by seungyooooong on 5/9/25.
//

import UIKit

final class TimerView: BaseView {
    private let timerView = {
        let view = UIView()
        view.backgroundColor = .grey700
        view.layer.cornerRadius = 142 / 2
        
        let imageView = UIImageView()
        imageView.image = .wait.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .blue300
        
        [imageView].forEach { view.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-20)
            $0.width.height.equalTo(20)
        }
        
        return view
    }()
    
    private let timeProgressView = {
        let view = UIView()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.blue300.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 6
        
        let viewSize: CGFloat = 142
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: viewSize / 2, y: viewSize / 2),
            radius: (viewSize - 6) / 2,
            startAngle: -CGFloat.pi / 2,
            endAngle: 1.5 * CGFloat.pi,
            clockwise: true
        )
        
        shapeLayer.path = circlePath.cgPath
        view.layer.addSublayer(shapeLayer)
            
        return view
    }()
    
    private let timerLabel = UILabel()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    private let timerStackView = UIStackView()
    
    override func configureView() {
        timerLabel.textColor = .grey0
        timerLabel.font = Fonts.head1B
        
        titleLabel.text = "내일부터 투두를 시작할 수 있어요!"
        titleLabel.textColor = .grey0
        titleLabel.font = Fonts.head2B
        
        subTitleLabel.text = "오늘은 계획을 세우고, 내일부터 실천해보세요!"
        subTitleLabel.textColor = .grey300
        subTitleLabel.font = Fonts.body2R
        
        timerStackView.axis = .vertical
        timerStackView.alignment = .center
    
        [timerView, titleLabel, subTitleLabel].forEach { timerStackView.addArrangedSubview($0) }
        timerStackView.setCustomSpacing(16, after: timerView)
        timerStackView.setCustomSpacing(4, after: titleLabel)
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [timerStackView, timeProgressView, timerLabel].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        timerView.snp.makeConstraints {
            $0.width.height.equalTo(142)
        }
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(28)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.height.equalTo(21)
        }
        
        timerStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        timeProgressView.snp.makeConstraints {
            $0.edges.equalTo(timerView)
        }
        
        timerLabel.snp.makeConstraints {
            $0.centerX.equalTo(timerView)
            $0.centerY.equalTo(timerView).offset(11)
            $0.height.equalTo(36)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? TimerViewDatas {
            timerLabel.text = datas.time
            (timeProgressView.layer.sublayers?.first as? CAShapeLayer)?.strokeEnd = datas.timeProgress
        }
    }
}
