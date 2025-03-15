//
//  LoggerManager.swift
//  dogether
//
//  Created by Jae hyung Kim on 3/7/25.
//

import Foundation
import os.log

/// 로거를 사용하는 객체입니다.
///
///     Example)
///
///     logger.info("TEST")
///     logger.debug(a,b,c,d,e,f)
///     ... etc
///
///     결과값
///        📗 INFO - SETTINGS ACTION
///     - from file: .../DND/dnd-12th-1-iOS/dogether/Utility/Extension/UIGestureRecognizerExt.swift
///     - function: init(action:)
///     - line: 45
let logger = LoggerManager.self

/// 해당 객체로 접근 하지 마시오
final class LoggerManager: Sendable {
    private init() {}
}

extension LoggerManager {
    enum Level {
        /// 디버깅
        case debug
        /// 정보
        case info
        /// 오류
        case error
        
        fileprivate var category: String {
            switch self {
            case .debug: return "👀 DEBUG"
            case .info: return "📗 INFO"
            case .error: return "👿 ERROR"
            }
        }
        
        fileprivate var osLog: OSLog {
            switch self {
            case .debug: return OSLog.debug
            case .info: return OSLog.info
            case .error: return OSLog.error
            }
        }
        
        fileprivate var osLogType: OSLogType {
            switch self {
            case .debug: return .debug
            case .info: return .info
            case .error: return .error
            }
        }
    }
    
    static private func log(_ logMessage: String, level: Level) {
        os_log("%{public}@", log: level.osLog, type: level.osLogType, logMessage)
    }
}

extension LoggerManager {
    static func debug(_ message: Any, _ arguments: Any..., file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        let message = makeMessage(message, arguments, file: file, function: function, line: line, level: .debug)
        log(message, level: .debug)
    }
    
    static func info(_ message: Any, _ arguments: Any..., file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        let message = makeMessage(message, arguments, file: file, function: function, line: line, level: .info)
        log(message, level: .info)
    }
  
    static func error(_ message: Any, _ arguments: Any..., file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        let message = makeMessage(message, arguments, file: file, function: function, line: line, level: .error)
        log(message, level: .error)
    }
}

extension LoggerManager {
    static private func makeMessage(_ message: Any, _ arguments: [Any], file: StaticString, function: StaticString, line: UInt, level: Level) -> String {
        let extraMessage = arguments.map { String(describing: $0) }.joined(separator: " ")
        return """
        \(level.category) - \(message) \(extraMessage)
        - from file: \(file)
        - function: \(function)
        - line: \(line)
        """
    }
}

extension OSLog {
    static let subsystem = Bundle.main.bundleIdentifier ?? "site.dogether"
    static let debug = OSLog(subsystem: subsystem, category: "Debug")
    static let info = OSLog(subsystem: subsystem, category: "Info")
    static let error = OSLog(subsystem: subsystem, category: "Error")
}
