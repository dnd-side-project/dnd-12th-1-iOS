//
//  RankingImageView.swift
//  dogether
//
//  Created by seungyooooong on 5/5/25.
//

import UIKit

enum RankingViewTypes {
    case topView
    case tableView
    
    var imageSize: CGFloat {
        switch self {
        case .topView:
            return 52
        case .tableView:
            return 44
        }
    }
    
    var indicatorSize: CGFloat {
        switch self {
        case .topView:
            return 60
        case .tableView:
            return 50
        }
    }
    
    var lineWidth: CGFloat {
        switch self {
        case .topView:
            return 2
        case .tableView:
            return 1.5
        }
    }
}

final class RankingImageView: BaseView {
    private let viewType: RankingViewTypes
    private(set) var readStatus: HistoryReadStatus?
    
    init(viewType: RankingViewTypes, readStatus: HistoryReadStatus? = nil) {
        self.viewType = viewType
        self.readStatus = readStatus
        
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let indicatorView = UIView()
    private let gradientLayer = CAGradientLayer()
    private let shapeLayer = CAShapeLayer()
    
    private let imageView = UIImageView(image: .logo)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        indicatorView.layer.cornerRadius = viewType.indicatorSize / 2
        gradientLayer.frame = indicatorView.bounds

        let path = UIBezierPath(
            roundedRect: indicatorView.bounds.insetBy(dx: shapeLayer.lineWidth / 2, dy: shapeLayer.lineWidth / 2),
            cornerRadius: indicatorView.layer.cornerRadius
        )
        shapeLayer.path = path.cgPath
    }
    
    override func configureView() {
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.mask = shapeLayer
        
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = viewType.lineWidth
        shapeLayer.strokeColor = UIColor.black.cgColor
        
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = viewType.imageSize / 2
        imageView.clipsToBounds = true
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [indicatorView, imageView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        indicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(viewType.indicatorSize)
        }
        
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(viewType.imageSize)
        }
    }
    
    func setImage(image: UIImage?) {
        imageView.image = image
    }
    
    func setReadStatus(readStatus: HistoryReadStatus?) {
        self.readStatus = readStatus
        
        gradientLayer.colors = readStatus?.colors
        indicatorView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        indicatorView.layer.addSublayer(gradientLayer)
    }
}
