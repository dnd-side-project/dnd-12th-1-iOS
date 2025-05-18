//
//  ThumbnailView.swift
//  dogether
//
//  Created by seungyooooong on 4/20/25.
//

import UIKit

enum ThumbnailStatus {
    case yet
    case done
}

// FIXME: 추후 BaseImageView로 수정
final class ThumbnailView: BaseView {
    private(set) var imageUrl: String?
    private(set) var thumbnailStatus: ThumbnailStatus
    private(set) var isHighlighted: Bool
    
    init(imageUrl: String?, thumbnailStatus: ThumbnailStatus, isHighlighted: Bool = false) {
        self.imageUrl = imageUrl
        self.thumbnailStatus = thumbnailStatus
        self.isHighlighted = isHighlighted
        
        super.init(frame: .zero)
        
        Task { [weak self] in
            guard let self, let imageUrl, let url = URL(string: imageUrl) else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            let image = UIImage(data: data)
            
            guard let image else { return }
            imageView.image = image
            
            imageView.snp.remakeConstraints {
                $0.center.equalToSuperview()
                $0.width.height.equalToSuperview()
            }
        }
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let imageView = UIImageView(image: .embarrassedDosik)
    
    private let doneOverlay = {
        let view = UIView()
        view.backgroundColor = .grey800.withAlphaComponent(0.8)
        view.layer.cornerRadius = 12
        return view
    }()
    
    override func configureView() {
        updateUI()
        
        backgroundColor = .grey800
        layer.cornerRadius = 12
        layer.borderWidth = 1
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
    }
    
    override func configureAction() {
        
    }
    
    override func configureHierarchy() {
        [imageView, doneOverlay].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        self.snp.makeConstraints {
            $0.width.height.equalTo(54)
        }
        
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().offset(-20) // MARK: 기본 이미지에서 임의로 크기 조정
        }
        
        doneOverlay.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension ThumbnailView {
    func setStatus(status: ThumbnailStatus) {
        self.thumbnailStatus = status
        
        updateUI()
    }
    
    func setIsHighlighted(isHighlighted: Bool) {
        self.isHighlighted = isHighlighted
        
        updateUI()
    }
    
    private func updateUI() {
        doneOverlay.isHidden = thumbnailStatus != .done
        layer.borderColor = isHighlighted ? UIColor.grey0.cgColor : UIColor.clear.cgColor
    }
}
