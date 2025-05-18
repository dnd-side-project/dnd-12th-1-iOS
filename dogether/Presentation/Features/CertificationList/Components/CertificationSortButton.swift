//
//  CertificationSortButton.swift
//  dogether
//
//  Created by yujaehong on 4/25/25.
//

import UIKit

enum CertificationSortOption: String, CaseIterable, BottomSheetItemRepresentable {
    case todoCompletionDate = "투두 완료일순"
    case groupCreationDate = "그룹 생성일순"

    var displayName: String {
        return self.rawValue
    }
    
    var bottomSheetItem: BottomSheetItem {
        BottomSheetItem(displayName: displayName, value: self)
    }
}

/// 투두 완료일순/그룹생성일순 옵션을 선택하는 버튼
final class CertificationSortButton: BaseButton {

    weak var delegate: BottomSheetDelegate?
    
    let sortTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let arrowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "chevron-down"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private var isSelectedFilter: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureView() {
        backgroundColor = .clear
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor.grey500.cgColor
        clipsToBounds = true
    }
    
    override func configureAction() {
        arrowButton.addAction(
            UIAction { [weak self] _ in
                guard let self = self, self.isSelectedFilter else { return }
                self.delegate?.presentBottomSheet()
            },
            for: .touchUpInside
        )
    }
    
    func updateSelectedOption(_ option: BottomSheetItem) {
        sortTitleLabel.text = option.displayName
        setIsSelectedFilter(true)
    }
    
    override func configureHierarchy() {
        addSubview(sortTitleLabel)
        addSubview(arrowButton)
    }
    
    override func configureConstraints() {
        snp.makeConstraints {
            $0.width.equalTo(116)
            $0.height.equalTo(32)
        }
        
        sortTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        
        arrowButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(19)
        }
    }
}

extension CertificationSortButton {
    func setIsSelectedFilter(_ selected: Bool) {
        self.isSelectedFilter = selected
        updateUI()
    }
    
    private func updateUI() {
        if isSelectedFilter {
            sortTitleLabel.textColor = .grey0
            arrowButton.setImage(UIImage(named: "chevron-down-blue"), for: .normal)
            layer.borderColor = UIColor.grey0.cgColor
        } else {
            sortTitleLabel.textColor = .grey400
            arrowButton.setImage(UIImage(named: "chevron-down"), for: .normal)
            layer.borderColor = UIColor.grey400.cgColor
        }
    }
}
