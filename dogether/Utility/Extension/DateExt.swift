//
//  DateExt.swift
//  dogether
//
//  Created by seungyooooong on 3/12/25.
//

import Foundation

extension Date {
    func getRemainTime() -> TimeInterval {
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: self)!
        return calendar.startOfDay(for: tomorrow).timeIntervalSince(self)
    }
    
    func toString(format: String = "yyyy.MM.dd") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
