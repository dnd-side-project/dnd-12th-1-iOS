//
//  CreateTodosRequest.swift
//  dogether
//
//  Created by seungyooooong on 2/4/25.
//

import Foundation

struct CreateTodosRequest: Encodable {
    let todos: [String]
}
