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
    
    private let placeHolder = UILabel()
    private let textCountLabel = UILabel()
    private let maxLengthLabel = UILabel()
    
    private(set) var currentText: String?
    private(set) var currentIsShowKeyboard: Bool?

    override func configureView() {
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
            string: type.placeHolder,
            attributes: Fonts.getAttributes(for: Fonts.body1S, textAlignment: .left)
        )
        placeHolder.textColor = .grey300
        placeHolder.numberOfLines = 0
        placeHolder.lineBreakMode = .byWordWrapping
        
        textCountLabel.font = Fonts.smallS
        
        maxLengthLabel.text = "/\(type.maxLength)"
        maxLengthLabel.textColor = .grey400
        maxLengthLabel.font = Fonts.smallS
    }
    
    override func configureAction() { }
        
    override func configureHierarchy() {
        [placeHolder, textCountLabel, maxLengthLabel].forEach { addSubview($0) }
    }
     
    override func configureConstraints() {
        placeHolder.snp.makeConstraints {
            // FIXME: 8.5 -> 16
            // ???: 좀 떨어져있음 (border or cornerRadius 의심 중)
            $0.top.equalToSuperview().offset(8.5)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.width.equalToSuperview().offset(-32)
        }
        
        textCountLabel.snp.makeConstraints {
            // FIXME: bottom.inset(16)
            // ???: superview의 bottom이 top쪽으로 잡힘
            $0.top.equalToSuperview().inset(type.tempTopInset)
            $0.right.equalTo(maxLengthLabel.snp.left)
            $0.height.equalTo(18)
        }
        
        maxLengthLabel.snp.makeConstraints {
            // FIXME: bottom.inset(16)
            // ???: superview의 bottom이 top쪽으로 잡힘
            $0.top.equalToSuperview().inset(type.tempTopInset)
            $0.right.equalToSuperview().inset(16)
            $0.height.equalTo(18)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? DogetherTextViewDatas {
            if currentText != datas.text {
                currentText = datas.text
                
                placeHolder.isHidden = datas.text.count > 0
                textCountLabel.text = String(datas.text.count)
            }
            
            if currentIsShowKeyboard != datas.isShowKeyboard {
                currentIsShowKeyboard = datas.isShowKeyboard
                
                layer.borderColor = datas.isShowKeyboard ? UIColor.blue300.cgColor : UIColor.clear.cgColor
                textCountLabel.textColor = datas.isShowKeyboard ? .blue300 : .grey400
            }
        }
    }
}

// MARK: for enum
extension DogetherTextView {
    enum TextViewTypes {
        case certification
        case examination
        
        var placeHolder: String {
            switch self {
            case .certification:
                return "팀원이 이해하기 쉽도록 인증에 대한\n설명을 입력하세요."
            case .examination:
                return "텍스트를 입력하세요"
            }
        }
        
        var maxLength: Int {
            switch self {
            case .certification:
                return 40
            case .examination:
                return 60
            }
        }
        
        var tempTopInset: Int {
            switch self {
            case .certification:
                return 75
            case .examination:
                return 105
            }
        }
    }
}

// MARK: - ViewDatas
struct DogetherTextViewDatas: BaseEntity {
    var text: String
    var isShowKeyboard: Bool
    
    init(text: String = "", isShowKeyboard: Bool = false) {
        self.text = text
        self.isShowKeyboard = isShowKeyboard
    }
}
