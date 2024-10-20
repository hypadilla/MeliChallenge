//
//  Logger.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import Foundation

enum LogLevel: String {
    case debug = "[DEBUG]"
    case error = "[ERROR]"
    case info = "[INFO]"
}

struct Logger {
    static func log(_ message: String, level: LogLevel = .debug, file: String = #file, line: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("\(level.rawValue) [\(fileName):\(line)] - \(message)")
        #endif
    }
}
