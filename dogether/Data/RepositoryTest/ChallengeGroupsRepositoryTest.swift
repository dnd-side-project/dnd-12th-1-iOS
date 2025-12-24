//
//  ChallengeGroupsRepositoryTest.swift
//  dogether
//
//  Created by seungyooooong on 3/30/25.
//

import Foundation

final class ChallengeGroupsRepositoryTest: ChallengeGroupsProtocol {
    func createTodos(groupId: String, createTodosRequest: CreateTodosRequest) async throws { }
    
    func getMyTodos(groupId: String, date: String) async throws -> [TodoEntity] {
        let certify_pendings = (1 ... 2).map {
            TodoEntity(id: $0, content: "testTodo \($0)", status: .waitCertification)
        }
        let review_pendings = (3 ... 4).map {
            TodoEntity(id: $0, content: "testTodo \($0)", status: .waitExamination, certificationContent: "test todo content \($0)")
        }
        let approves = (5 ... 6).map {
            TodoEntity(id: $0, content: "testTodo \($0)", status: .approve, certificationContent: "test todo content \($0)")
        }
        let rejects = (7 ... 8).map {
            TodoEntity(
                id: $0, content: "testTodo \($0)testTodo \($0)testTodo \($0)", status: .reject,
                certificationContent: "test todo content \($0)test todo content \($0)test todo content \($0)", reviewFeedback: "test todo reject reason \($0)test todo reject reason \($0)test todo reject reason \($0)test todo reject reason \($0)"
            )
        }
        return certify_pendings + review_pendings + approves + rejects
    }
    
    func getMemberTodos(groupId: Int, memberId: Int) async throws -> (index: Int, todos: [TodoEntity]) {
        return (index: 3, todos: [
            TodoEntity(id: 1, content: "신규 기능 개발", status: .waitCertification, thumbnailStatus: .done),
            TodoEntity(id: 2, content: "치킨 먹기", status: .waitCertification, thumbnailStatus: .done, certificationContent: "치킨 냠냠", reviewFeedback: ""),
            TodoEntity(id: 1, content: "신규 기능 개발", status: .waitCertification, thumbnailStatus: .done, reviewFeedback: "test"),
            TodoEntity(id: 2, content: "치킨 먹기", status: .waitCertification, thumbnailStatus: .done, certificationContent: "치킨 냠냠"),
            TodoEntity(id: 1, content: "신규 기능 개발", status: .waitExamination, thumbnailStatus: .yet),
            TodoEntity(id: 2, content: "치킨 먹기", status: .waitExamination, thumbnailStatus: .yet, certificationContent: "치킨 냠냠", certificationMediaUrl: "https://dogether-bucket-dev.s3.ap-northeast-2.amazonaws.com/daily-todo-proof-media/mock/e.png"),
            TodoEntity(id: 1, content: "신규 기능 개발", status: .waitExamination, thumbnailStatus: .yet, certificationMediaUrl: "https://dogether-bucket-dev.s3.ap-northeast-2.amazonaws.com/daily-todo-proof-media/mock/e1.png"),
            TodoEntity(id: 2, content: "치킨 먹기", status: .approve, thumbnailStatus: .yet, certificationContent: "치킨 냠냠", certificationMediaUrl: "https://dogether-bucket-dev.s3.ap-northeast-2.amazonaws.com/daily-todo-proof-media/mock/e1.png"),
            TodoEntity(id: 1, content: "신규 기능 개발", status: .approve, thumbnailStatus: .yet),
            TodoEntity(id: 2, content: "치킨 먹기", status: .approve, thumbnailStatus: .yet, certificationContent: "치킨 냠냠"),
            TodoEntity(id: 1, content: "신규 기능 개발", status: .approve, thumbnailStatus: .yet),
            TodoEntity(id: 2, content: "치킨 먹기", status: .approve, thumbnailStatus: .yet, certificationContent: "치킨 냠냠"),
            TodoEntity(id: 1, content: "신규 기능 개발", status: .reject, thumbnailStatus: .yet),
            TodoEntity(id: 2, content: "치킨 먹기", status: .reject, thumbnailStatus: .yet, certificationContent: "치킨 냠냠"),
            TodoEntity(id: 1, content: "신규 기능 개발", status: .reject, thumbnailStatus: .yet),
            TodoEntity(id: 2, content: "치킨 먹기", status: .reject, thumbnailStatus: .yet, certificationContent: "치킨 냠냠")
        ])
    }
    
    func readTodo(todoId: String) async throws { }
    
    func certifyTodo(todoId: String, certifyTodoRequest: CertifyTodoRequest) async throws { }
}
