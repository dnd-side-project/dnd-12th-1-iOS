//
//  SkeletonView.swift
//  dogether
//
//  Created by seungyooooong on 11/13/25.
//

import Foundation

final class SkeletonView: BaseView {
    override func configureView() {
        backgroundColor = .grey700
        layer.cornerRadius = 8
    }
}
