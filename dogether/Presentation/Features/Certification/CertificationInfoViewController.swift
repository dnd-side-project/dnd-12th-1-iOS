//
//  CertificationInfoViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/16/25.
//

import UIKit
import SnapKit

final class CertificationInfoViewController: BaseViewController {
    var todoInfo = TodoInfo(id: 0, content: "", status: "")
    
    private let navigationHeader = NavigationHeader(title: "내 인증 정보")
    
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
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview().inset(10)
        }
        
        return view
    }
    private var rejectReasonView = UIView()
    
    override func configureView() {
        imageView = CertificationImageView(
            image: .logo,
            certificationContent: todoInfo.certificationContent
        )
        
        Task { [weak self] in
            guard let self else { return }
            try await imageView.loadImage(url: todoInfo.certificationMediaUrl)
        }
            
        guard let status = TodoStatus(rawValue: todoInfo.status),
              let filterType = FilterTypes.allCases.first(where: { $0.tag == status.tag }) else { return }
        statusView = FilterButton(type: filterType)
        
        contentLabel.attributedText = NSAttributedString(
            string: todoInfo.content,
            attributes: Fonts.getAttributes(for: Fonts.head1B, textAlignment: .center)
        )
        
        if let rejectReason = todoInfo.rejectReason { rejectReasonView = rejectReasonView(reason: rejectReason) }
    }
    
    override func configureAction() {
        navigationHeader.delegate = self
    }
    
    override func configureHierarchy() {
        [navigationHeader, imageView, statusView, contentLabel].forEach { view.addSubview($0) }
        
        if todoInfo.rejectReason != nil { view.addSubview(rejectReasonView) }
    }
     
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(imageView.snp.width)
        }
        
        statusView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(32)
            $0.height.equalTo(32)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(statusView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        if todoInfo.rejectReason != nil {
            rejectReasonView.snp.makeConstraints {
                $0.top.equalTo(contentLabel.snp.bottom).offset(16)
                $0.horizontalEdges.equalToSuperview().inset(16)
            }
        }
    }
}
