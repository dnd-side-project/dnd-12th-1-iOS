//
//  RejectReasonPopupView.swift
//  dogether
//
//  Created by seungyooooong on 2/17/25.
//

import UIKit
import SnapKit

final class RejectReasonPopupView: BasePopupView {
    // MARK: - PopupViewController에서 action handling
    let rejectReasonButton = DogetherButton(title: "등록하기", status: .disabled)
    
    // MARK: - PopupViewController에서 delegate 지정
    let rejectReasonTextView = DogetherTextView(type: .rejectReason)
    
    init() {
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let closeButton = {
        let button = UIButton()
        button.setImage(.close.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .grey0
        return button
    }()
    
    private let descriptionLabel = {
        let label = UILabel()
        label.text = "이유를 들려주세요 !"
        label.textColor = .grey0
        label.textAlignment = .center
        label.font = Fonts.head1B
        return label
    }()
    
    private let descriptionView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.grey600.cgColor
        view.layer.borderWidth = 1
        
        let imageView = UIImageView(image: .notice)
        
        let label = UILabel()
        label.text = "한번 등록한 피드백은 바꿀 수 없어요"
        label.textColor = .grey400
        label.font = Fonts.body2S
        
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        [stackView].forEach { view.addSubview($0) }
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        return view
    }()
    
    override func configureView() { }
    
    override func configureAction() {
        closeButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                delegate?.hidePopup()
            }, for: .touchUpInside
        )
    }
     
    override func configureHierarchy() {
        [closeButton, descriptionLabel, descriptionView, rejectReasonTextView, rejectReasonButton].forEach { addSubview($0) }
    }
     
    override func configureConstraints() {
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-20)
            $0.width.height.equalTo(24)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(36)
        }
        
        descriptionView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        rejectReasonTextView.snp.makeConstraints {
            $0.top.equalTo(descriptionView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(160)
        }
        
        rejectReasonButton.snp.makeConstraints {
            $0.top.equalTo(rejectReasonTextView.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().inset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
