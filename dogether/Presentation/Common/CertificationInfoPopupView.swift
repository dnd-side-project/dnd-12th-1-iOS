//
//  CertificationInfoPopupView.swift
//  dogether
//
//  Created by seungyooooong on 2/16/25.
//

import Foundation
import UIKit
import SnapKit

final class CertificationInfoPopupView: UIView {
    
    private var todoInfo: TodoInfo
    
    let dismissButtonTapped: () -> Void
    
    init(
        todoInfo: TodoInfo,
        dismissButtonTapped: @escaping () -> Void
    ) {
        self.todoInfo = todoInfo
        self.dismissButtonTapped = dismissButtonTapped
        super.init(frame: .zero)
        setUI()
        
        Task.detached(priority: .medium) { [weak self] in
            guard let weakSelf = self else { return }
            
            guard let mediaUrl = todoInfo.certificationMediaUrl,
                  let url = URL(string: mediaUrl) else {
                return
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            await MainActor.run {
                weakSelf.imageView.image = UIImage(data: data)
            }
        }
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "인증 정보"
        label.textColor = .grey0
        label.font = Fonts.head2B
        return label
    }()
    
    private let closeButton = {
        let button = UIButton()
        button.setImage(.close.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .grey0
        return button
    }()
    
    private var imageView = UIImageView()
    
    private var statusView = FilterButton(type: .all)
    
    private let contentLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.numberOfLines = 0
        return label
    }()
    
    private func rejectReasonView(reason: String) -> UIView {
        let view = UIView()
        view.backgroundColor = .grey600
        view.layer.cornerRadius = 8
        
        let label = UILabel()
        label.attributedText = NSAttributedString(
            string: reason,
            attributes: Fonts.getAttributes(for: Fonts.body1S, textAlignment: .left)
        )
        label.textColor = .grey100
        label.numberOfLines = 0
        
        view.addSubview(label)
        
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        return view
    }
    private var rejectReasonView = UIView()
    
    private func setUI() {
        backgroundColor = .grey700
        layer.cornerRadius = 12
        
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        
        // TODO: 추후 수정
        imageView = CertificationImageView(
            image: .logo,
            certificationContent: todoInfo.certificationContent ?? "",
            certificator: UserDefaultsManager.shared.userFullName ?? ""
        )
        
        guard let status = TodoStatus(rawValue: todoInfo.status),
              let filterType = FilterTypes.allCases.first(where: { $0.tag == status.tag }) else { return }
        statusView = FilterButton(type: filterType)
        
        contentLabel.attributedText = NSAttributedString(
            string: todoInfo.content,
            attributes: Fonts.getAttributes(for: Fonts.head1B, textAlignment: .center)
        )
        
        [titleLabel, closeButton, imageView, statusView, contentLabel].forEach { addSubview($0) }
        
        self.snp.updateConstraints {
            $0.height.equalTo(531)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(28)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-20)
            $0.width.height.equalTo(24)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(303)
        }
        
        statusView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.height.equalTo(32)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(statusView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(72)
        }
        
        if let rejectReason = todoInfo.rejectReason {
            rejectReasonView = rejectReasonView(reason: rejectReason)
            addSubview(rejectReasonView)
            rejectReasonView.snp.makeConstraints {
                $0.top.equalTo(contentLabel.snp.bottom).offset(16)
                $0.horizontalEdges.equalToSuperview().inset(20)
                $0.height.equalTo(70)
            }
            
            self.snp.updateConstraints {
                $0.height.equalTo(617)
            }
        }
    }
    
    @objc private func didTapCloseButton() {
//        PopupManager.shared.hidePopup()
        dismissButtonTapped()
    }
}
