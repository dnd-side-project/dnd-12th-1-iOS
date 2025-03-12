//
//  LoggerManager.swift
//  dogether
//
//  Created by Jae hyung Kim on 3/7/25.
//

import Foundation
import os.log

let logger = LoggerManager.self

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
            case .debug:
                return " 👀 DEBUG 👀 "
            case .info:
                return " 📗 INFO 📗 "
            case .error:
                return " 👿 ERROR 👿 "
            }
        }
        
        fileprivate var osLog: OSLog {
            switch self {
            case .debug:
                return OSLog.debug
            case .info:
                return OSLog.info
            case .error:
                return OSLog.error
            }
        }
        
        fileprivate var osLogType: OSLogType {
            switch self {
            case .debug:
                return .debug
            case .info:
                return .info
            case .error:
                return .error
            }
        }
    }
    
    static private func log(_ message: Any, _ arguments: [Any], level: Level) {
        
        let extraMessage = arguments
            .map{
                String(describing: $0)
            }
            .joined(separator: " ")
        
        let logger = Logger(subsystem: OSLog.subsystem, category: level.category)
        let logMessage = "\(message) \(extraMessage)"
        switch level {
        case .debug:
#if DEBUG
            logger.debug("\(logMessage, privacy: .public)")
#endif
        case .info:
#if DEBUG || Release
            logger.info("\(logMessage, privacy: .public)")
#endif
        case .error:
#if DEBUG || Release
            logger.error("\(logMessage, privacy: .public)")
#endif
        }
    }
    
}

extension LoggerManager {
    static func debug(_ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .debug)
    }
    
    static func info(_ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .info)
    }
  
    static func error(_ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .error)
    }
}


extension OSLog {
    static let subsystem = Bundle.main.bundleIdentifier ?? "site.dogether"
    static let debug = OSLog(subsystem: subsystem, category: "Debug")
    static let info = OSLog(subsystem: subsystem, category: "Info")
    static let error = OSLog(subsystem: subsystem, category: "Error")
}
