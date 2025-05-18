//
//  MainUseCase.swift
//  dogether
//
//  Created by seungyooooong on 3/7/25.
//

import Foundation

final class MainUseCase {
    func getTodosInfo(dateOffset: Int, currentFilter: FilterTypes) async throws -> (String, TodoStatus?) {
        let date = DateFormatterManager.formattedDate(dateOffset).split(separator: ".").joined(separator: "-")
        let status: TodoStatus? = currentFilter == .all ? nil : TodoStatus.allCases.first(where: { $0.tag == currentFilter.tag })
        return (date, status)
    }
}
