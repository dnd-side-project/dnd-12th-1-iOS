//
//  ErrorViewModel.swift
//  dogether
//
//  Created by seungyooooong on 12/17/25.
//

import Foundation

import RxRelay

final class ErrorViewModel {
    private(set) var buttonViewDatas = BehaviorRelay<DogetherButtonViewDatas>(value: DogetherButtonViewDatas())
}
