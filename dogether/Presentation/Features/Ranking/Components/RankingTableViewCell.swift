//
//  RankingTableViewCell.swift
//  dogether
//
//  Created by seungyooooong on 3/30/25.
//

import UIKit

final class RankingTableViewCell: BaseTableViewCell, ReusableProtocol {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let tableViewCell = RankingView()
    
    override func configureView() {
        selectionStyle = .none
        backgroundColor = .clear
    }
     
    override func configureAction() { }
    
    override func configureHierarchy() {
        contentView.addSubview(tableViewCell)
    }
     
    override func configureConstraints() {
        tableViewCell.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.verticalEdges.equalToSuperview().inset(10)
        }
    }
}

extension RankingTableViewCell {
    func setExtraInfo(ranking: RankingModel) {
        tableViewCell.setExtraInfo(ranking: ranking)
    }
}
