//
//  FilterStackView.swift
//  dogether
//
//  Created by seungyooooong on 12/11/25.
//

import Foundation

final class FilterStackView: BaseStackView {
    var mainDelegate: MainDelegate? {
        didSet {
            [allButton, waitButton, approveButton, rejectButton].forEach { $0.mainDelegate = mainDelegate }
        }
    }
    
    var certificationListDelegate: CertificationListPageDelegate? {
        didSet {
            [allButton, waitButton, approveButton, rejectButton].forEach { $0.certificationListDelegate = certificationListDelegate }
        }
    }
    
    private let allButton = FilterButton(type: .all)
    private let waitButton = FilterButton(type: .wait)
    private let rejectButton = FilterButton(type: .reject)
    private let approveButton = FilterButton(type: .approve)
    
    override func configureView() {
        axis = .horizontal
        spacing = 8
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [allButton, waitButton, approveButton, rejectButton].forEach { addArrangedSubview($0) }
    }
    
    override func configureConstraints() { }
    
    // MARK: - updateView
    override func updateView(_ data: any BaseEntity) {
        if let datas = data as? FilterTypes {
            [allButton, waitButton, rejectButton, approveButton].forEach { $0.updateView(datas) }
        }
    }
}
