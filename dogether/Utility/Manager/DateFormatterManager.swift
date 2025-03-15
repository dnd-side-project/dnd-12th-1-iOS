//
//  DateFormatterManager.swift
//  dogether
//
//  Created by seungyooooong on 2/11/25.
//

import Foundation

struct DateFormatterManager {
    private static let locale = Locale(identifier: "ko_KR")
    private static let timeZone = TimeZone(identifier: "ko_KR")
    
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.timeZone = timeZone
        return formatter
    }()
    
    static func formattedDate(_ days: Int = 0) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        let returnDate = Calendar.current.date(byAdding: .day, value: days, to: Date()) ?? Date()
        return formatter.string(from: returnDate)
    }
    
    static func today() -> String {
        formatter.dateFormat = Format.MdE.rawValue
        return formatter.string(from: Date())
    }
}

extension DateFormatterManager {
    
    enum Format: String {
        case MdE = "M월 d일 E요일"
    }
}
