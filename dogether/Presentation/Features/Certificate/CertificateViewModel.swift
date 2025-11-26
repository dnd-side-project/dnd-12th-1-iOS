//
//  CertificateViewModel.swift
//  dogether
//
//  Created by seungyooooong on 7/13/25.
//

import UIKit

final class CertificateViewModel {
    private let challengeGroupUseCase: ChallengeGroupUseCase
    
    var todoInfo = TodoEntity(id: 0, content: "", status: .waitCertification)

    init() {
        let repository = DIManager.shared.getChallengeGroupsRepository()
        self.challengeGroupUseCase = ChallengeGroupUseCase(repository: repository)
    }
}

extension CertificateViewModel {
    func setText(_ text: String) {
        todoInfo.certificationContent = text
    }
}

extension CertificateViewModel {
    func certifyTodo() async throws {
        guard let content = todoInfo.certificationContent, let mediaUrl = todoInfo.certificationMediaUrl else { return }
        try await challengeGroupUseCase.certifyTodo(todoId: todoInfo.id, content: content, mediaUrl: mediaUrl)
    }
    
    func uploadImage(image: UIImage) async throws{
        todoInfo.certificationMediaUrl = try await S3Manager.shared.uploadImage(image: image)
    }
}
