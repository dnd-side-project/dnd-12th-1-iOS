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
    
    /// 주어진 값(일 수)을 현재 날짜에 더한 후, 지정된 형식으로 변환하여 반환합니다.
    ///
    /// - Parameters:
    ///   - value: 현재 날짜에 더할 (또는 뺄) 일 수입니다. 기본값은 `0`입니다.
    ///   - format: 변환할 날짜 형식입니다. 기본값은 `.yyyyMMdd`입니다.
    /// - Returns: 날짜를 지정된 형식으로 변환한 문자열입니다.
    ///
    /// - Example:
    /// ```swift
    /// let today = DateFormatterManager.formattedDate() // "2025.03.30"
    /// let tomorrow = DateFormatterManager.formattedDate(1) // "2025.03.31"
    /// let todayMdE = DateFormatterManager.formattedDate(format: .Mde) // "3월 30일 일요일"
    /// ```
    static func formattedDate(_ value: Int = 0, format: DateFormats = .yyyyMMdd) -> String {
        formatter.dateFormat = format.rawValue
        return formatter.string(from: Calendar.current.date(byAdding: .day, value: value, to: Date()) ?? Date())
    }
}

extension DateFormatterManager {
    enum DateFormats: String {
        case yyyyMMdd = "yyyy.MM.dd"
        case MdE = "M월 d일 E요일"
    }
}
