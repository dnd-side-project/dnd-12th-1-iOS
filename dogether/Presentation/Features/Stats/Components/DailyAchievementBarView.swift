//
//  DailyAchievementBarView.swift
//  dogether
//
//  Created by yujaehong on 4/30/25.
//

import UIKit
import SnapKit

final class DailyAchievementBarView: BaseView {
    private let barMaxHeight: CGFloat = 187
    
    private var dailyAchievements: [CertificationPeriod] = []
    
    private let titleIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .today2
        imageView.tintColor = .grey0
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "인증한 기간"
        label.font = Fonts.body1S
        label.textColor = .grey0
        return label
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleIconImageView, titleLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    
    private let yAxisStackView: UIStackView = {
        let values = [10, 8, 6, 4, 2, 0].map {
            let label = UILabel()
            label.text = "\($0)"
            label.font = Fonts.body2S
            label.textColor = .grey500
            return label
        }
        let stack = UIStackView(arrangedSubviews: values)
        stack.axis = .vertical
        stack.spacing = 15
        stack.alignment = .leading
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let barStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20
        stack.alignment = .bottom
        return stack
    }()
    
    private let dayLabelStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20
        stack.alignment = .top
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func configureView() {
        backgroundColor = .grey800
        layer.cornerRadius = 12
        clipsToBounds = true
    }
    
    override func configureAction() {}
    
    override func configureHierarchy() {
        addSubview(titleStackView)
        addSubview(yAxisStackView)
        addSubview(barStackView)
        addSubview(dayLabelStackView)
    }
    
    override func configureConstraints() {
        titleIconImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        
        titleStackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
            $0.height.equalTo(25)
        }
        
        yAxisStackView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(57)
            $0.leading.equalToSuperview().offset(25)
            $0.width.equalTo(16)
            $0.height.equalTo(201)
        }
        
        barStackView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(68)
            $0.leading.equalTo(yAxisStackView.snp.trailing).offset(20)
            $0.height.equalTo(barMaxHeight)
        }
        
        dayLabelStackView.snp.makeConstraints {
            $0.top.equalTo(barStackView.snp.bottom).offset(10)
            $0.leading.equalTo(barStackView)
            $0.height.equalTo(20)
        }
    }
}

extension DailyAchievementBarView {
    private func configureBars() {
        barStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        dayLabelStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let data = dailyAchievements.suffix(4)
        
        for (index, achievement) in data.enumerated() {
            let barContainer = UIView()
            barContainer.snp.makeConstraints {
                $0.width.equalTo(50)
                $0.height.equalTo(barMaxHeight)
            }
            
            let backgroundBar = UIView()
            backgroundBar.layer.cornerRadius = 4
            backgroundBar.clipsToBounds = true
            barContainer.addSubview(backgroundBar)
            
            backgroundBar.snp.makeConstraints {
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(barMaxHeight * CGFloat(achievement.createdCount) / 10.0)
            }
            
            let backgroundImageView = UIImageView()
            backgroundImageView.image = .background2
            backgroundImageView.contentMode = .scaleAspectFill
            backgroundImageView.clipsToBounds = true
            backgroundBar.addSubview(backgroundImageView)
            backgroundImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
            
            let filledBar = UIView()
            filledBar.backgroundColor = (index == data.count - 1) ? .blue300 : .blue200
            filledBar.layer.cornerRadius = 4
            filledBar.clipsToBounds = true
            backgroundBar.addSubview(filledBar)
            
            filledBar.snp.makeConstraints {
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalToSuperview().multipliedBy(CGFloat(achievement.certificationRate) / 100.0)
            }
            
            if index == data.count - 1 {
                addSpeechBubble(to: barContainer, ratio: CGFloat(achievement.certificationRate) / 100.0)
            }
            
            barStackView.addArrangedSubview(barContainer)
            
            let dayLabel = UILabel()
            dayLabel.text = "\(achievement.day)일차"
            dayLabel.font = Fonts.body2S
            dayLabel.textColor = .grey0
            dayLabel.textAlignment = .center
            dayLabel.snp.makeConstraints {
                $0.width.equalTo(50)
            }
            dayLabelStackView.addArrangedSubview(dayLabel)
        }
    }
    
    private func addSpeechBubble(to container: UIView, ratio: CGFloat) {
        let bubbleContainer = UIView()
        bubbleContainer.backgroundColor = .blue300
        bubbleContainer.clipsToBounds = true
        container.addSubview(bubbleContainer)
        
        let bubbleLabel = UILabel()
        bubbleLabel.text = "\(Int(ratio * 100))% 달성중"
        bubbleLabel.font = Fonts.body2S
        bubbleLabel.textColor = .grey0
        bubbleLabel.textAlignment = .center
        bubbleContainer.addSubview(bubbleLabel)
        
        bubbleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
        
        bubbleContainer.snp.makeConstraints {
            $0.centerX.equalTo(container)
            $0.bottom.equalTo(container.subviews[0].snp.top).offset(-20)
            $0.height.equalTo(30)
            $0.width.greaterThanOrEqualTo(89)
        }
        
        bubbleContainer.layer.cornerRadius = 15
        
        let tailImageView = UIImageView(image: .blueTail)
        tailImageView.tintColor = .blue300
        tailImageView.contentMode = .scaleAspectFit
        container.addSubview(tailImageView)
        
        tailImageView.snp.makeConstraints {
            $0.top.equalTo(bubbleContainer.snp.bottom).offset(-4)
            $0.centerX.equalTo(bubbleContainer)
            $0.size.equalTo(12)
        }
        
        let pointCircleImageView = UIImageView(image: .pointCircle)
        pointCircleImageView.contentMode = .scaleAspectFit
        container.addSubview(pointCircleImageView)
        
        pointCircleImageView.snp.makeConstraints {
            $0.centerX.equalTo(tailImageView)
            $0.top.equalTo(tailImageView.snp.bottom).offset(3)
            $0.size.equalTo(12)
        }
    }
}

extension DailyAchievementBarView {
    func configure(achievements: [CertificationPeriod]) {
        dailyAchievements = achievements.suffix(4)
        configureBars()
    }
}
