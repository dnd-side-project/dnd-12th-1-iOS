//
//  CertificationViewModel.swift
//  dogether
//
//  Created by seungyooooong on 10/18/25.
//

import RxRelay

final class CertificationViewModel {
    private let challengeGroupsUseCase: ChallengeGroupUseCase
    
    private(set) var certificationViewDatas = BehaviorRelay<CertificationViewDatas>(value: CertificationViewDatas())
    
    init() {
        let challengeGroupsRepository = DIManager.shared.getChallengeGroupsRepository()
        self.challengeGroupsUseCase = ChallengeGroupUseCase(repository: challengeGroupsRepository)
    }
}

extension CertificationViewModel {
    func setIndex(index: Int) async throws {
        if certificationViewDatas.value.rankingEntity == nil {
            certificationViewDatas.update { $0.index = index }
        } else {
            // MARK: 이전에 보고 있던 thumbnailStatus를 수정하고 이동한 todo의 read API를 호출
            certificationViewDatas.update { $0.todos[certificationViewDatas.value.index].thumbnailStatus = .done }
            certificationViewDatas.update { $0.index = index }
            try await readTodo(index: index)
        }
    }
    
    func readTodo(index: Int? = nil) async throws {
        try await challengeGroupsUseCase.readTodo(
            todo: certificationViewDatas.value.todos[index ?? certificationViewDatas.value.index]
        )
    }
}
