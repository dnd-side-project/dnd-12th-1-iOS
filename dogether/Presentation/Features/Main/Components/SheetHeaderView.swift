//
//  SheetHeaderView.swift
//  dogether
//
//  Created by seungyooooong on 4/27/25.
//

import UIKit

final class SheetHeaderView: BaseView {
    var delegate: MainDelegate? {
        didSet {
            prevButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.goPastAction()
                }, for: .touchUpInside
            )
            
            nextButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.goFutureAction()
                }, for: .touchUpInside
            )
        }
    }
    
    private let dateLabel = UILabel()
    private let dateSkeletonView = SkeletonView()
    
    private let prevButton = UIButton()
    private let nextButton = UIButton()
    
    private var currentGroupDuration: Int?
    private var currentDateOffset: Int?
    private var isFirst: Bool = true
    
    override func configureView() {
        dateLabel.text = "2000.01.01"
        dateLabel.textColor = .grey0
        dateLabel.font = Fonts.head2B
        
        prevButton.setImage(.prevButton, for: .normal)
        prevButton.setImage(.prevButtonDisabled, for: .disabled)
        prevButton.tag = Directions.prev.tag
        prevButton.isEnabled = false
        
        nextButton.setImage(.nextButton, for: .normal)
        nextButton.setImage(.nextButtonDisabled, for: .disabled)
        nextButton.tag = Directions.next.tag
        nextButton.isEnabled = false
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [dateLabel, prevButton, nextButton].forEach { addSubview($0) }
        
        dateLabel.addSubview(dateSkeletonView)
    }
    
    override func configureConstraints() {
        dateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        prevButton.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.width.height.equalTo(32)
        }
        
        nextButton.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.width.height.equalTo(32)
        }
        
        dateSkeletonView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? GroupViewDatas {
            if currentGroupDuration == datas.groups[datas.index].duration { return }
            currentGroupDuration = datas.groups[datas.index].duration
        }
        
        if let datas = data as? SheetViewDatas {
            // FIXME: 추후 최적화 필요
            /// sheetViewDatas의 dateOffset과 groupViewDatas의 duration이 함께 작용해서 결과를 만들기 때문에
            /// 단순히 currentDateOffset과 datas.dateOffset을 비교하는 방식으로는 최적화가 불가능,
            /// 현재는 최적화 작업 없이 계속 updateView를 호출하는 상황, 추후 최적화

            guard let currentGroupDuration else { return }
            if isFirst {
                isFirst = false
                
                dateSkeletonView.removeFromSuperview()
            }
            
            currentDateOffset = datas.dateOffset
            dateLabel.text = DateFormatterManager.formattedDate(datas.dateOffset)
            
            prevButton.isEnabled = datas.dateOffset * -1 < currentGroupDuration - 1
            nextButton.isEnabled = datas.dateOffset < 0
        }
    }
}
