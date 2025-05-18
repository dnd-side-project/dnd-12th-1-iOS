//
//  DogetherTextView.swift
//  dogether
//
//  Created by seungyooooong on 4/2/25.
//

import UIKit

final class DogetherTextView: BaseTextView {
    // TODO: paste 처리 추가
    
    let type: TextViewTypes
    
    init(type: TextViewTypes) {
        self.type = type
        super.init(frame: .zero, textContainer: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let placeHolder = {
        let label = UILabel()
        label.textColor = .grey300
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let textCountLabel = {
        let label = UILabel()
        label.font = Fonts.smallS
        return label
    }()
    
    private let maxLengthLabel = {
        let label = UILabel()
        label.textColor = .grey400
        label.font = Fonts.smallS
        return label
    }()

    override func configureView() {
        updateTextInfo()
        focusOn()
        
        text = ""
        textColor = .grey50
        font = Fonts.body1S
        
        tintColor = .blue300
        returnKeyType = .done
        
        textContainer.lineFragmentPadding = 0
        textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        backgroundColor = .grey800
        layer.cornerRadius = 12
        layer.borderWidth = 1
        
        placeHolder.attributedText = NSAttributedString(
            string: "팀원이 이해하기 쉽도록 인증에 대한\n설명을 입력하세요.",
            attributes: Fonts.getAttributes(for: Fonts.body1S, textAlignment: .left)
        )
        
        maxLengthLabel.text = "/\(type.maxLength)"
    }
    
    override func configureAction() { }
        
    override func configureHierarchy() {
        [placeHolder, textCountLabel, maxLengthLabel].forEach { addSubview($0) }
    }
     
    override func configureConstraints() {
        placeHolder.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8.5) // FIXME: 8.5 -> 16   // ???: 좀 떨어져있음 (border or cornerRadius 의심 중)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.width.equalToSuperview().offset(-32)
        }
        
        textCountLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(type.tempTopInset) // FIXME: bottom.inset(16)  // ???: superview의 bottom이 top쪽으로 잡힘
            $0.right.equalTo(maxLengthLabel.snp.left)
            $0.height.equalTo(18)
        }
        
        maxLengthLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(type.tempTopInset) // FIXME: bottom.inset(16)  // ???: superview의 bottom이 top쪽으로 잡힘
            $0.right.equalToSuperview().inset(16)
            $0.height.equalTo(18)
        }
    }
}

// MARK: delegate func
extension DogetherTextView {
    func updateTextInfo() {
        placeHolder.isHidden = text.count > 0
        textCountLabel.text = String(text.count)
    }
    
    func focusOn() {
        layer.borderColor = UIColor.blue300.cgColor
        textCountLabel.textColor = .blue300
    }
    
    func focusOff() {
        layer.borderColor = UIColor.clear.cgColor
        textCountLabel.textColor = .grey400
    }
}

// MARK: for enum
extension DogetherTextView {
    enum TextViewTypes {
        case certification
        case rejectReason
        
        var placeHolder: String {
            switch self {
            case .certification:
                return "팀원이 이해하기 쉽도록 인증에 대한 설명을 입력하세요."
            case .rejectReason:
                return "노인정에 대한 피드백이 필요해요.\n어떤 부분이 부족한지 정확하게 적어주세요!"
            }
        }
        
        var maxLength: Int {
            switch self {
            case .certification:
                return 40
            case .rejectReason:
                return 60
            }
        }
        
        var tempTopInset: Int {
            switch self {
            case .certification:
                return 75
            case .rejectReason:
                return 130
            }
        }
    }
}
