//
//  Log.swift
//  AppStoreSample
//
//  Created by Jinwoo Kim on 8/30/21.
//

import Foundation
import SwiftyBeaver
import RxSwift
import RxCocoa

// swiftlint:disable type_name
typealias log = LogImpl

final class LogImpl: Log {
    
    static let triggeredLog: PublishRelay<LogData> = .init()
    
    static var isEnabledSaveToFile: Bool = true {
        didSet {
            if isEnabledSaveToFile {
                if !_Log.destinations.contains(fileDestination) {
                    _Log.addDestination(fileDestination)
                }
            } else {
                _Log.removeDestination(fileDestination)
            }
        }
    }
    
    static let logFileURL: URL = {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Logs")
            .appendingPathComponent("log")
            .appendingPathExtension("txt")
    }()
    
    static var doesLogFileExists: Bool {
        return FileManager.default.fileExists(atPath: logFileURL.path)
    }
    
    private typealias _Log = SwiftyBeaver
    private static let fileDestination: FileDestination = .init(logFileURL: logFileURL)
    private static let consoleDestination: ConsoleDestination = .init()
    
    private static var didSetup: Bool = false
    
    static func error(_ message: Any, file: String, function: String, line: Int) {
        initialize()
        _Log.error(message, file, function, line: line)
        triggeredLog.accept(.error(message))
    }
    
    static func warning(_ message: Any, file: String, function: String, line: Int) {
        initialize()
        _Log.warning(message, file, function, line: line)
        triggeredLog.accept(.warning(message))
    }
    
    static func info(_ message: Any, file: String, function: String, line: Int) {
        initialize()
        _Log.info(message, file, function, line: line)
        triggeredLog.accept(.info(message))
    }
    
    static func debug(_ message: Any, file: String, function: String, line: Int) {
        initialize()
        _Log.debug(message, file, function, line: line)
        triggeredLog.accept(.debug(message))
    }
    
    static func verbose(_ message: Any, file: String, function: String, line: Int) {
        initialize()
        _Log.verbose(message, file, function, line: line)
        triggeredLog.accept(.verbose(message))
    }
    
    static private func initialize() {
        guard !didSetup else {
            return
        }
        
        if isEnabledSaveToFile {
            _Log.addDestination(fileDestination)
        }
        _Log.addDestination(consoleDestination)
        
        didSetup = true
    }
}
