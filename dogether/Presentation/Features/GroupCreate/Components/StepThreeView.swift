//
//  StepThreeView.swift
//  dogether
//
//  Created by seungyooooong on 11/10/25.
//

import Foundation

final class StepThreeView: BaseView {
    private let dogetherGroupInfo = DogetherGroupInfo()
    
    override func configureView() { }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [dogetherGroupInfo].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        dogetherGroupInfo.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(267)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? GroupCreateViewDatas {
            let viewData = DogetherGroupInfoViewData(
                name: datas.groupName,
                memberCount: datas.memberCount,
                duration: datas.duration,
                startDay: DateFormatterManager.formattedDate(datas.startAt.daysFromToday),
                endDay: DateFormatterManager.formattedDate(datas.startAt.daysFromToday + datas.duration.rawValue)
            )
            dogetherGroupInfo.updateView(viewData)
        }
    }
}
