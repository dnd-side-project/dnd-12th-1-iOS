//
//  TimerView.swift
//  dogether
//
//  Created by seungyooooong on 5/9/25.
//

import UIKit

final class TimerView: BaseView {
    init() { super.init(frame: .zero) }
    required init?(coder: NSCoder) { fatalError() }
    
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
    
    private let timerLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.font = Fonts.head1B
        return label
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "내일부터 투두를 시작할 수 있어요!"
        label.textColor = .grey0
        label.font = Fonts.head2B
        return label
    }()
    
    private let subTitleLabel = {
        let label = UILabel()
        label.text = "오늘은 계획을 세우고, 내일부터 실천해보세요!"
        label.textColor = .grey300
        label.font = Fonts.body2R
        return label
    }()
    
    private let timerStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    override func configureView() {
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
}

extension TimerView {
    func updateTimer(time: String, timeProgress: CGFloat) {
        timerLabel.text = time
        (timeProgressView.layer.sublayers?.first as? CAShapeLayer)?.strokeEnd = timeProgress
    }
}
