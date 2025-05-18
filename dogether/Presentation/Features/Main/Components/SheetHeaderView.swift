//
//  SheetHeaderView.swift
//  dogether
//
//  Created by seungyooooong on 4/27/25.
//

import UIKit

final class SheetHeaderView: BaseView {
    private(set) var date: String
    
    init(date: String = "2000.01.01") {
        self.date = date
        
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let dateLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.font = Fonts.head2B
        return label
    }()
    
    let prevButton = {
        let button = UIButton()
        button.setImage(.prevButton, for: .normal)
        button.setImage(.prevButtonDisabled, for: .disabled)
        button.isEnabled = false
        button.tag = Directions.prev.tag
        return button
    }()
    
    let nextButton = {
        let button = UIButton()
        button.setImage(.nextButton, for: .normal)
        button.setImage(.nextButtonDisabled, for: .disabled)
        button.isEnabled = false
        button.tag = Directions.next.tag
        return button
    }()
    
    override func configureView() {
        updateUI()
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [dateLabel, prevButton, nextButton].forEach { addSubview($0) }
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
    }
}

extension SheetHeaderView {
    func setDate(date: String) {
        self.date = date
        
        updateUI()
    }
    
    private func updateUI() {
        dateLabel.text = date
    }
}
