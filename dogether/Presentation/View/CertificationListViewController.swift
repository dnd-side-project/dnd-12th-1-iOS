//
//  CertificationListViewController.swift
//  dogether
//
//  Created by 박지은 on 2/18/25.
//

import UIKit
import SnapKit

struct SectionData {
    let title: String
    let date: String
    let images: [UIImage]
    let button: UIButton
}

final class CertificationListViewController: BaseViewController {
    
    private var buttonStackView = UIStackView()
    
    private lazy var allButton = FilterButton(type: .all) { self.updateTodoList(type: $0) }
    
    private lazy var waitButton = FilterButton(type: .wait, isColorful: false) { self.updateTodoList(type: $0) }
                                               
    private lazy var rejectButton = FilterButton(type: .reject, isColorful: false) { self.updateTodoList(type: $0) }
    
    private lazy var approveButton = FilterButton(type: .approve, isColorful: false) { self.updateTodoList(type: $0) }
    
    private lazy var collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CertificationListCollectionViewCell.self,
                                forCellWithReuseIdentifier: CertificationListCollectionViewCell.identifier)
        collectionView.register(CertificationListHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CertificationListHeaderView.identifier)
        return collectionView
    }()
    
    private let sections: [SectionData] = [
        SectionData(title: "2일차",
                    date: "2025.01.02 (화)",
                    images: [.sample, .sample, .sample],
                    button: FilterButton(type: .approve)),
        SectionData(title: "1일차",
                    date: "2025.01.01 (월)",
                    images: [.sample, .sample],
                    button: FilterButton(type: .wait))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        [buttonStackView, collectionView].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(28)
            $0.left.equalToSuperview().offset(16)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(buttonStackView.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        navigationItem.title = "인증 목록"
        buttonStackView = filterButtonStackView(buttons: [allButton,
                                                          waitButton,
                                                          rejectButton,
                                                          approveButton])
    }
    
    private func filterButtonStackView(buttons: [UIButton]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }
    
    private func updateTodoList(type: FilterTypes) {
        allButton.setIsColorful(type == .all)
        waitButton.setIsColorful(type == .wait)
        rejectButton.setIsColorful(type == .reject)
        approveButton.setIsColorful(type == .approve)
    }
    
    private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 11
        let itemWidth = 166
        let itemHeight = 166
        
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        layout.minimumInteritemSpacing = spacing
        
        return layout
    }
}

final class CertificationListHeaderView: UICollectionReusableView, ReusableProtocol {
    
    private let titleLabel = {
        let label = UILabel()
        label.font = Fonts.head2B
        label.textColor = .grey0
        return label
    }()
    
    private let dateLabel = {
        let label = UILabel()
        label.font = Fonts.body1S
        label.textColor = .grey400
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [titleLabel, dateLabel].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.equalToSuperview()
        }
    }
    
    func configure(title: String, date: String) {
        titleLabel.text = title
        dateLabel.text = date
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
}

extension CertificationListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return sections[section].images.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CertificationListCollectionViewCell.identifier,
                                                      for: indexPath) as! CertificationListCollectionViewCell
        
        let sectionData = sections[indexPath.section]
        let imageName = sectionData.images[indexPath.item]
        let button = sectionData.button
        
        cell.configure(imageName: imageName, button: button)
        cell.layer.cornerRadius = 12
        cell.clipsToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: CertificationListHeaderView.identifier,
                                                                           for: indexPath) as? CertificationListHeaderView else {
            return UICollectionReusableView()
        }
        
        let sectionData = sections[indexPath.section]
        header.configure(title: sectionData.title, date: sectionData.date)
        
        return header
    }
}

extension CertificationListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}
