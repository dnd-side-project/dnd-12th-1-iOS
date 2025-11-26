//
//  ThumbnailView.swift
//  dogether
//
//  Created by seungyooooong on 4/20/25.
//

import UIKit

final class ThumbnailView: BaseView {
    private let imageView = UIImageView(image: .embarrassedDosik)
    private let doneOverlayView = UIView()
    
    private(set) var currentImageUrl: String?
    private(set) var currentThumbnailStatus: ThumbnailStatus?
    private(set) var currentIsHighlizghted: Bool?
    
    override func configureView() {
        backgroundColor = .grey800
        layer.cornerRadius = 12
        layer.borderWidth = 1
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        
        doneOverlayView.backgroundColor = .grey800.withAlphaComponent(0.8)
        doneOverlayView.layer.cornerRadius = 12
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [imageView, doneOverlayView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        self.snp.makeConstraints {
            $0.width.height.equalTo(54)
        }
        
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().offset(-20) // MARK: 기본 이미지에서 임의로 크기 조정
        }
        
        doneOverlayView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? ThumbnailViewDatas {
            if currentImageUrl != datas.imageUrl {
                currentImageUrl = datas.imageUrl
                
                Task { [weak self] in
                    guard let self, let imageUrl = datas.imageUrl, let url = URL(string: imageUrl) else { return }
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
            
            if currentThumbnailStatus != datas.thumbnailStatus {
                currentThumbnailStatus = datas.thumbnailStatus
                
                doneOverlayView.isHidden = datas.thumbnailStatus != .done
            }
            
            if currentIsHighlizghted != datas.isHighlighted {
                currentIsHighlizghted = datas.isHighlighted
                
                layer.borderColor = datas.isHighlighted ? UIColor.grey0.cgColor : UIColor.clear.cgColor
            }
        }
    }
}
