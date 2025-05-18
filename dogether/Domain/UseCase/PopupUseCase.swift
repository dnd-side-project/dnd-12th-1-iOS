//
//  PopupUseCase.swift
//  dogether
//
//  Created by seungyooooong on 4/2/25.
//

import Foundation

final class PopupUseCase {
    private let repository: PopupProtocol
    
    init(repository: PopupProtocol) {
        self.repository = repository
    }
    
    func certifyTodo(todoId: String, certifyTodoRequest: CertifyTodoRequest) async throws {
        try await repository.certifyTodo(todoId: todoId, certifyTodoRequest: certifyTodoRequest)
    }
}
