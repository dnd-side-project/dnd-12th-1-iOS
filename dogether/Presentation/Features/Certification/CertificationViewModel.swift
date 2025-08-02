//
//  CertificationViewModel.swift
//  dogether
//
//  Created by seungyooooong on 7/13/25.
//

import UIKit

final class CertificationViewModel {
    private let challengeGroupUseCase: ChallengeGroupUseCase
    
    var todoInfo = TodoInfo(id: 0, content: "", status: "")

    init() {
        let repository = DIManager.shared.getChallengeGroupsRepository()
        self.challengeGroupUseCase = ChallengeGroupUseCase(repository: repository)
    }
}

extension CertificationViewModel {
    func setText(_ text: String) {
        todoInfo.certificationContent = text
    }
}

extension CertificationViewModel {
    func certifyTodo() async throws {
        guard let content = todoInfo.certificationContent, let mediaUrl = todoInfo.certificationMediaUrl else { return }
        try await challengeGroupUseCase.certifyTodo(todoId: todoInfo.id, content: content, mediaUrl: mediaUrl)
    }
    
    func uploadImage(image: UIImage) async throws{
        todoInfo.certificationMediaUrl = try await S3Manager.shared.uploadImage(image: image)
    }
}
