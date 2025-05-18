//
//  PopupProtocol.swift
//  dogether
//
//  Created by seungyooooong on 4/2/25.
//

import Foundation

protocol PopupProtocol {
    func certifyTodo(todoId: String, certifyTodoRequest: CertifyTodoRequest) async throws
}
