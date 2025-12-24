//
//  CertificateViewModel.swift
//  dogether
//
//  Created by seungyooooong on 7/13/25.
//

import UIKit

import RxRelay

final class CertificateViewModel {
    private let challengeGroupUseCase: ChallengeGroupUseCase
    
    private(set) var certificateViewDatas = BehaviorRelay<CertificateViewDatas>(value: CertificateViewDatas())
    private(set) var certificateTextViewDatas = BehaviorRelay<DogetherTextViewDatas>(value: DogetherTextViewDatas())
    private(set) var certificateButtonViewDatas = BehaviorRelay<DogetherButtonViewDatas>(
        value: DogetherButtonViewDatas(status: .disabled)
    )

    init() {
        let repository = DIManager.shared.getChallengeGroupsRepository()
        self.challengeGroupUseCase = ChallengeGroupUseCase(repository: repository)
    }
}

extension CertificateViewModel {
    func updateButtonStatus(status: ButtonStatus) {
        certificateButtonViewDatas.update { $0.status = status }
    }
    
    func updateIsFirstResponder(isFirstResponder: Bool) {
        certificateViewDatas.update { $0.isFirstResponder = isFirstResponder }
        certificateTextViewDatas.update { $0.isShowKeyboard = isFirstResponder }
    }
    
    func updateKeyboardHeight(height: CGFloat) {
        certificateViewDatas.update { $0.keyboardHeight = height }
    }
    
    func updateContent(content: String) {
        certificateViewDatas.update { $0.todo.certificationContent = content }
        certificateTextViewDatas.update { $0.text = content }
        certificateButtonViewDatas.update { $0.status = content.count > 0 ? .enabled : .disabled }
    }
}

extension CertificateViewModel {
    func uploadImage(image: UIImage) async throws{
        let mediaUrl = try await S3Manager.shared.uploadImage(image: image)
        
        certificateViewDatas.update {
            $0.todo.certificationMediaUrl = mediaUrl
        }
    }
    
    func certifyTodo() async throws {
        let todo = certificateViewDatas.value.todo
        guard let content = todo.certificationContent,
              let mediaUrl = todo.certificationMediaUrl else { return }
        try await challengeGroupUseCase.certifyTodo(todoId: todo.id, content: content, mediaUrl: mediaUrl)
    }
}
