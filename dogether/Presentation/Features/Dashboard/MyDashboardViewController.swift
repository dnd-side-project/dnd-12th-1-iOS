////
////  MyDashboardViewController.swift
////  dogether
////
////  Created by 박지은 on 2/14/25.
////
//
//import UIKit
//import SnapKit
//
//final class MyDashboardViewController: BaseViewController {
//    private let scrollView = {
//        let scrollView = UIScrollView()
//        scrollView.showsVerticalScrollIndicator = false
//        return scrollView
//    }()
//    
//    private let contentView = UIView()
//    
//    private let contentStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.spacing = 20
//        return stackView
//    }()
//    
//    private let messageLabel = {
//        let label = UILabel()
//        let myTodoMessage = "대단해요!\n총 0개의 투두를 달성했어요"
//        
//        let attributedText = NSMutableAttributedString(string: myTodoMessage)
//        
//        if let range = myTodoMessage.range(of: "123개") {
//            let nsRagne = NSRange(range, in: myTodoMessage)
//            attributedText.addAttribute(.foregroundColor, value: UIColor.blue300, range: nsRagne)
//        }
//        
//        label.attributedText = attributedText
//        label.font = Fonts.head1B
//        label.numberOfLines = 0
//        return label
//    }()
//    
//    private lazy var myDataCollectionView = {
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createMyDataCollectionLayout())
//        collectionView.backgroundColor = .clear
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.register(MyDashboardCollectionViewCell.self, forCellWithReuseIdentifier: MyDashboardCollectionViewCell.identifier)
//        return collectionView
//    }()
//    
//    private var items: [(UIImage, String, String)] = [
//        (image: .certification, title: "달성 개수", count: "0개"),
//        (image: .approve, title: "인정 개수", count: "0개"),
//        (image: .reject, title: "노인정 개수", count: "0개")
//    ]
//    
//    // MARK: - 인증한 기간
//    private let progressStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.spacing = 20
//        stackView.alignment = .bottom
//        stackView.distribution = .equalSpacing
//        stackView.backgroundColor = .grey700
//        stackView.layer.cornerRadius = 12
//        return stackView
//    }()
//    
//    private let calendarIcon = {
//        let icon = UIImageView()
//        icon.image = .today.withRenderingMode(.alwaysTemplate)
//        icon.tintColor = .grey0
//        return icon
//    }()
//    
//    private let progressTitleLabel = {
//        let label = UILabel()
//        label.text = "인증한 기간"
//        label.font = Fonts.head2B
//        label.textColor = .grey0
//        return label
//    }()
//    
//    private let progressYLabels = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.spacing = 15
//        stackView.distribution = .equalSpacing
//        stackView.alignment = .leading
//        
//        let yLabels = ["10", "8", "6", "4", "2", "0"]
//        for text in yLabels {
//            let label = UILabel()
//            label.text = text
//            label.font = Fonts.body2S
//            label.textColor = .grey500
//            stackView.addArrangedSubview(label)
//        }
//        return stackView
//    }()
//    
//    private func createProgressView(title: String, progress: Float, isToday: Bool = false) -> UIStackView {
//        // 프로그레스바 전체
//        let progressBarContainer = StripedView()
//        
//        progressBarContainer.backgroundColor = .grey500
//        progressBarContainer.layer.cornerRadius = 10
//        progressBarContainer.clipsToBounds = true
//        
//        // 프로그레스바 실행률
//        let progressBar = UIView()
//        progressBar.backgroundColor = isToday ? .blue300 : .blue200
//        progressBar.layer.cornerRadius = 8
//        
//        progressBarContainer.addSubview(progressBar)
//        
//        progressBarContainer.snp.makeConstraints {
//            $0.width.equalTo(50)
//            $0.height.equalTo(180)
//        }
//        
//        progressBar.snp.makeConstraints {
//            $0.bottom.leading.trailing.equalToSuperview()
//            $0.height.equalToSuperview().multipliedBy(progress)
//        }
//        
//        let label = UILabel()
//        label.text = title
//        label.font = Fonts.body2R
//        
//        let stackView = UIStackView(arrangedSubviews: [progressBarContainer, label])
//        stackView.axis = .vertical
//        stackView.spacing = 10
//        stackView.alignment = .center
//        
//        if isToday {
//            let progressLabel = UILabel()
//            progressLabel.text = "20% 달성중"
//            progressLabel.font = .systemFont(ofSize: 14)
//            progressLabel.textColor = .grey0
//            progressLabel.backgroundColor = .blue300
//            progressLabel.layer.cornerRadius = 20
//            progressLabel.layer.masksToBounds = true
//            progressLabel.textAlignment = .center
//            
//            let circleView = UIView()
//            circleView.backgroundColor = .blue300
//            circleView.layer.borderColor = UIColor.white.cgColor
//            circleView.layer.borderWidth = 2
//            circleView.layer.cornerRadius = 1
//            
//            stackView.addSubview(circleView)
//            
//            circleView.snp.makeConstraints {
//                $0.bottom.equalTo(progressBarContainer.snp.top).offset(4)
//                $0.centerX.equalTo(progressBar)
//                $0.width.height.equalTo(9)
//            }
//            
//            [progressLabel].forEach {
//                stackView.addSubview($0)
//            }
//            
//            progressLabel.snp.makeConstraints {
//                $0.bottom.equalTo(progressBarContainer.snp.top).offset(-16)
//                $0.centerX.equalTo(progressBar)
//                $0.width.equalTo(90)
//                $0.height.equalTo(36)
//            }
//        }
//        return stackView
//    }
//    
//    // MARK: - 인증 목록
//    private let certificationStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.spacing = 6
//        stackView.distribution = .equalSpacing
//        stackView.backgroundColor = .grey700
//        stackView.layer.cornerRadius = 12
//        return stackView
//    }()
//    
//    private let certificationIcon = {
//        let icon = UIImageView()
//        icon.image = UIImage(systemName: "list.bullet")
//        icon.tintColor = .grey0
//        return icon
//    }()
//    
//    private let certificationTitleLabel = {
//        let label = UILabel()
//        label.text = "인증 목록"
//        label.font = Fonts.head2B
//        label.textColor = .grey0
//        return label
//    }()
//    
//    private let goToCertificationDetailIcon = {
//        let icon = UIImageView()
//        icon.image = .chevronRight.withRenderingMode(.alwaysTemplate)
//        icon.tintColor = .grey400
//        return icon
//    }()
//    
//    private lazy var certificationCollectionView = {
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCeritificationCollectionLayout())
//        collectionView.backgroundColor = .clear
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.register(CertificationCollectionViewCell.self, forCellWithReuseIdentifier: CertificationCollectionViewCell.identifier)
//        return collectionView
//        
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        configureProgressBars()
//        fetchMySummary()
//    }
//    
//    override func configureView() { }
//    
//    override func configureAction() { }
//    
//    override func configureHierarchy() {
//        [scrollView].forEach { view.addSubview($0) }
//        
//        [contentView, contentStackView].forEach { scrollView.addSubview($0) }
//        
//        [messageLabel, myDataCollectionView, progressStackView, certificationStackView].forEach {
//            contentStackView.addArrangedSubview($0)
//        }
//        
//        [calendarIcon, progressTitleLabel, progressYLabels].forEach {
//            progressStackView.addSubview($0)
//        }
//        
//        [certificationIcon, certificationTitleLabel, goToCertificationDetailIcon, certificationCollectionView].forEach {
//            certificationStackView.addSubview($0)
//        }
//    }
//    
//    override func configureConstraints() {
//        scrollView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//        
//        contentView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//            $0.width.equalToSuperview()
//        }
//        
//        contentStackView.snp.makeConstraints {
//            $0.edges.equalToSuperview().inset(16)
//            $0.width.equalToSuperview().offset(-32)
//        }
//        
//        myDataCollectionView.snp.makeConstraints {
//            $0.top.equalTo(messageLabel.snp.bottom).offset(40)
//            $0.height.equalTo(107)
//        }
//        
//        progressStackView.snp.makeConstraints {
//            $0.top.equalTo(myDataCollectionView.snp.bottom).offset(20)
//            $0.height.equalTo(343)
//        }
//        
//        calendarIcon.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(20)
//            $0.leading.equalToSuperview().offset(17)
//            $0.width.height.equalTo(20)
//        }
//        
//        progressTitleLabel.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(20)
//            $0.leading.equalTo(calendarIcon.snp.trailing).offset(9)
//        }
//        
//        progressYLabels.snp.makeConstraints {
//            $0.top.equalTo(progressTitleLabel.snp.bottom).offset(54)
//            $0.leading.equalToSuperview().offset(16)
//            $0.height.equalTo(201)
//        }
//        
//        certificationStackView.snp.makeConstraints {
//            $0.top.equalTo(progressStackView.snp.bottom).offset(20)
//            $0.height.equalTo(294)
//        }
//        
//        certificationIcon.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(24)
//            $0.leading.equalToSuperview().offset(16)
//            $0.width.height.equalTo(20)
//        }
//        
//        certificationTitleLabel.snp.makeConstraints {
//            $0.leading.equalTo(certificationIcon.snp.trailing).offset(8)
//            $0.centerY.equalTo(certificationIcon)
//        }
//        
//        goToCertificationDetailIcon.snp.makeConstraints {
//            $0.centerY.equalTo(certificationTitleLabel)
//            $0.width.height.equalTo(20)
//            $0.trailing.equalToSuperview().offset(-16)
//        }
//        
//        certificationCollectionView.snp.makeConstraints {
//            $0.top.equalTo(certificationTitleLabel.snp.bottom).offset(16)
//            $0.horizontalEdges.equalToSuperview().inset(16)
//            $0.height.equalTo(206)
//        }
//    }
//    
//    private func createMyDataCollectionLayout() -> UICollectionViewFlowLayout {
//        
//        let layout = UICollectionViewFlowLayout()
//        let spacing: CGFloat = 7
//        let itemWidth = 107
//        let itemHeight = 107
//        
//        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
//        layout.minimumLineSpacing = spacing
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.minimumInteritemSpacing = spacing
//        
//        return layout
//    }
//    
//    private func createCeritificationCollectionLayout() -> UICollectionViewFlowLayout {
//        
//        let layout = UICollectionViewFlowLayout()
//        let spacing: CGFloat = 4
//        let itemWidth = 101
//        let itemHeight = 101
//        
//        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
//        layout.minimumLineSpacing = spacing
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.minimumInteritemSpacing = spacing
//        
//        return layout
//    }
//    
//    private func configureProgressBars() {
//        
//        let progressData = [
//            ("1일차", 0.2),
//            ("2일차", 0.5),
//            ("3일차", 0.7),
//            ("4일차", 0.4)
//        ]
//        
//        // 프로그레스 바를 하나로 묶을 stackView
//        let progressBarsContainer = UIStackView()
//        
//        progressBarsContainer.spacing = 2
//        progressBarsContainer.distribution = .equalSpacing
//        
//        for (title, progress) in progressData {
//            
//            let isToday = (title == "4일차")
//            
//            let progressView = createProgressView(title: title, progress: Float(progress), isToday: isToday)
//            
//            if let label = progressView.subviews.first(where: { $0 is UILabel }) as? UILabel {
//                label.font = Fonts.body2S
//            }
//            
//            progressBarsContainer.addArrangedSubview(progressView)
//            
//            progressView.snp.makeConstraints {
//                $0.width.equalTo(50)
//            }
//        }
//        
//        progressStackView.addSubview(progressBarsContainer)
//        
//        progressBarsContainer.snp.makeConstraints {
//            $0.leading.equalToSuperview().offset(51)
//            $0.trailing.equalToSuperview().offset(-32)
//            $0.bottom.equalToSuperview().offset(-20)
//        }
//    }
//    
//    private func fetchMySummary() {
//        Task {
//            do {
//                let mySummary: GetMySummaryResponse = try await NetworkManager.shared.request(GroupsRouter.getMySummary)
//                
//                DispatchQueue.main.async {
//                    let messageLabel = "대단해요!\n총 \(mySummary.totalTodoCount)개의 투두를 달성했어요"
//                    
//                    let attributedText = NSMutableAttributedString(string: messageLabel)
//                    
//                    if let range = messageLabel.range(of: "\(mySummary.totalTodoCount)") {
//                        let nsRagne = NSRange(range, in: messageLabel)
//                        attributedText.addAttribute(.foregroundColor, value: UIColor.blue300, range: nsRagne)
//                    }
//                    self.messageLabel.attributedText = attributedText
//                    self.updateCollectionViewData(mySummary: mySummary)
//                }
//                
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
//}
//
//extension MyDashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == myDataCollectionView {
//            return 3
//        } else {
//            return 6
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView == myDataCollectionView {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyDashboardCollectionViewCell.identifier, for: indexPath) as! MyDashboardCollectionViewCell
//            
//            let item = items[indexPath.row]
//            
//            cell.backgroundColor = .grey700
//            cell.layer.cornerRadius = 12
//            cell.configure(with: item.0, title: item.1, count: item.2)
//            
//            return cell
//        } else {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CertificationCollectionViewCell.identifier, for: indexPath) as! CertificationCollectionViewCell
//            
//            cell.backgroundColor = .grey500
//            cell.layer.cornerRadius = 12
//            
//            return cell
//        }
//    }
//    
//    private func updateCollectionViewData(mySummary: GetMySummaryResponse) {
//        items = [
//            (image: .certification, title: "달성 개수", count: "\(mySummary.totalTodoCount)개"),
//            (image: .approve, title: "인정 개수", count: "\(mySummary.totalCertificatedCount)개"),
//            (image: .reject, title: "노인정 개수", count: "\(mySummary.totalRejectedCount)개")
//        ]
//        
//        myDataCollectionView.reloadData()
//    }
//}
//
//final class StripedView: UIView {
//    
//    override func draw(_ rect: CGRect) {
//        guard let context = UIGraphicsGetCurrentContext() else { return }
//        
//        let stripeColor = UIColor(white: 1.0, alpha: 0.3).cgColor
//        let stripeWidth: CGFloat = 5
//        let spacing: CGFloat = 10
//        
//        context.setLineWidth(stripeWidth)
//        context.setStrokeColor(stripeColor)
//        
//        for x in stride(from: -rect.height, to: rect.width, by: spacing) {
//            context.move(to: CGPoint(x: x, y: 0))
//            context.addLine(to: CGPoint(x: x + rect.height, y: rect.height))
//        }
//        context.strokePath()
//    }
//}
