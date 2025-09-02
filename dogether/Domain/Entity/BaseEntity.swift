//
//  BaseEntity.swift
//  dogether
//
//  Created by seungyooooong on 8/22/25.
//

/// Entity 내부 요소들을 옵저빙 하기 위해 Equatable을 채택합니다
/// 데이터 옵저빙 및 업데이트 범위를 파악하기 위해 Hashable을 채택합니다
protocol BaseEntity: Equatable, Hashable { }
