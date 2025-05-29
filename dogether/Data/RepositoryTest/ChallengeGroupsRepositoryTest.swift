//
//  ChallengeGroupsRepositoryTest.swift
//  dogether
//
//  Created by seungyooooong on 3/30/25.
//

import Foundation

final class ChallengeGroupsRepositoryTest: ChallengeGroupsProtocol {
    func createTodos(groupId: String, createTodosRequest: CreateTodosRequest) async throws { }
    
    func getMyTodos(groupId: String, date: String, status: String?) async throws -> GetMyTodosResponse {
        let certify_pendings = (1 ... 2).map { TodoInfo(id: $0, content: "testTodo \($0)", status: "CERTIFY_PENDING") }
        let review_pendings = (3 ... 4).map {
            TodoInfo(id: $0, content: "testTodo \($0)", status: "REVIEW_PENDING", certificationContent: "test todo content \($0)")
        }
        let approves = (5 ... 6).map {
            TodoInfo(id: $0, content: "testTodo \($0)", status: "APPROVE", certificationContent: "test todo content \($0)")
        }
        let rejects = (7 ... 8).map {
            TodoInfo(
                id: $0, content: "testTodo \($0)testTodo \($0)testTodo \($0)", status: "REJECT",
                certificationContent: "test todo content \($0)test todo content \($0)test todo content \($0)", reviewFeedback: "test todo reject reason \($0)test todo reject reason \($0)test todo reject reason \($0)test todo reject reason \($0)"
            )
        }
        if status == nil {
            let todos = certify_pendings + review_pendings + approves + rejects
            return GetMyTodosResponse(todos: todos)
        } else if status == "REVIEW_PENDING" {
            return GetMyTodosResponse(todos: review_pendings)
        } else if status == "APPROVE" {
            return GetMyTodosResponse(todos: approves)
        } else {
            return GetMyTodosResponse(todos: [])
        }
    }
    
    func getMemberTodos(groupId: String, memberId: String) async throws -> GetMemberTodosResponse {
        GetMemberTodosResponse(currentTodoHistoryToReadIndex: 3, todos: [
            MemberTodo(id: 1, content: "신규 기능 개발", status: "CERTIFY_PENDING", isRead: true),
            MemberTodo(id: 2, content: "치킨 먹기", status: "CERTIFY_PENDING", certificationContent: "치킨 냠냠", isRead: true),
            MemberTodo(id: 1, content: "신규 기능 개발", status: "CERTIFY_PENDING", isRead: true),
            MemberTodo(id: 2, content: "치킨 먹기", status: "CERTIFY_PENDING", certificationContent: "치킨 냠냠", isRead: true),
            MemberTodo(id: 1, content: "신규 기능 개발", status: "REVIEW_PENDING", isRead: false),
            MemberTodo(id: 2, content: "치킨 먹기", status: "REVIEW_PENDING", certificationContent: "치킨 냠냠", certificationMediaUrl: "https://dogether-bucket-dev.s3.ap-northeast-2.amazonaws.com/daily-todo-proof-media/mock/e.png", isRead: false),
            MemberTodo(id: 1, content: "신규 기능 개발", status: "REVIEW_PENDING", certificationMediaUrl: "https://dogether-bucket-dev.s3.ap-northeast-2.amazonaws.com/daily-todo-proof-media/mock/e1.png", isRead: false),
            MemberTodo(id: 2, content: "치킨 먹기", status: "APPROVE", certificationContent: "치킨 냠냠", certificationMediaUrl: "https://dogether-bucket-dev.s3.ap-northeast-2.amazonaws.com/daily-todo-proof-media/mock/e1.png", isRead: false),
            MemberTodo(id: 1, content: "신규 기능 개발", status: "APPROVE", isRead: false),
            MemberTodo(id: 2, content: "치킨 먹기", status: "APPROVE", certificationContent: "치킨 냠냠", isRead: false),
            MemberTodo(id: 1, content: "신규 기능 개발", status: "APPROVE", isRead: false),
            MemberTodo(id: 2, content: "치킨 먹기", status: "APPROVE", certificationContent: "치킨 냠냠", isRead: false),
            MemberTodo(id: 1, content: "신규 기능 개발", status: "REJECT", isRead: false),
            MemberTodo(id: 2, content: "치킨 먹기", status: "REJECT", certificationContent: "치킨 냠냠", isRead: false),
            MemberTodo(id: 1, content: "신규 기능 개발", status: "REJECT", isRead: false),
            MemberTodo(id: 2, content: "치킨 먹기", status: "REJECT", certificationContent: "치킨 냠냠", isRead: false)
        ])
    }
    
    func readTodo(todoId: String) async throws { }
}
