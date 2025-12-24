//
//  StepTwoView.swift
//  dogether
//
//  Created by seungyooooong on 11/10/25.
//

import UIKit

final class StepTwoView: BaseView {
    var delegate: GroupCreateDelegate? {
        didSet {
            [threeDaysButton, oneWeekButton, twoWeeksButton, fourWeeksButton].forEach { $0.delegate = delegate }
            [todayButton, tomorrowButton].forEach { $0.delegate = delegate }
        }
    }
    
    private let duration = UILabel()
    private let startAt = UILabel()
    
    private let threeDaysButton = DurationButton(duration: .threeDays)
    private let oneWeekButton = DurationButton(duration: .oneWeek)
    private let twoWeeksButton = DurationButton(duration: .twoWeeks)
    private let fourWeeksButton = DurationButton(duration: .fourWeeks)
    
    private let todayButton = StartAtButton(startAt: .today)
    private let tomorrowButton = StartAtButton(startAt: .tomorrow)
    
    private func horizontalStackView(buttons: [UIButton]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }
    private var durationRow1 = UIStackView()
    private var durationRow2 = UIStackView()
    private var startAtStack = UIStackView()
    
    private func verticalStackView(stacks: [UIStackView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: stacks)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }
    private var durationStack = UIStackView()
    
    override func configureView() {
        duration.text = "활동 기간"
        duration.textColor = .grey200
        duration.font = Fonts.body1B
        
        durationRow1 = horizontalStackView(buttons: [threeDaysButton, oneWeekButton])
        durationRow2 = horizontalStackView(buttons: [twoWeeksButton, fourWeeksButton])
        durationStack = verticalStackView(stacks: [durationRow1, durationRow2])
        
        startAt.text = "시작일"
        startAt.textColor = .grey200
        startAt.font = Fonts.body1B
        
        startAtStack = horizontalStackView(buttons: [todayButton, tomorrowButton])
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [duration, durationStack, startAt, startAtStack].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        duration.snp.makeConstraints {
            $0.top.equalToSuperview()
        }

        durationStack.snp.makeConstraints {
            $0.top.equalTo(duration.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(108)
        }

        startAt.snp.makeConstraints {
            $0.top.equalTo(durationStack.snp.bottom).offset(30)
        }

        startAtStack.snp.makeConstraints {
            $0.top.equalTo(startAt.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(166)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? GroupCreateViewDatas {
            [threeDaysButton, oneWeekButton, twoWeeksButton, fourWeeksButton].forEach { $0.updateView(datas.duration) }
            [todayButton, tomorrowButton].forEach { $0.updateView(datas.startAt) }
        }
    }
}
