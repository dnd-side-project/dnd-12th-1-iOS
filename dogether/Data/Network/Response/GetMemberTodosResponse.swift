//
//  GetMemberTodosResponse.swift
//  dogether
//
//  Created by seungyooooong on 4/29/25.
//

import Foundation

struct GetMemberTodosResponse: Decodable {
    let currentTodoHistoryToReadIndex: Int
    let todos: [MemberTodo]
}

struct MemberTodo: Decodable {
    let id: Int
    let content: String
    let status: String
    let certificationContent: String?
    let certificationMediaUrl: String?
    let isRead: Bool
    
    init(id: Int, content: String, status: String, certificationContent: String? = nil, certificationMediaUrl: String? = nil, isRead: Bool) {
        self.id = id
        self.content = content
        self.status = status
        self.certificationContent = certificationContent
        self.certificationMediaUrl = certificationMediaUrl
        self.isRead = isRead
    }
}
