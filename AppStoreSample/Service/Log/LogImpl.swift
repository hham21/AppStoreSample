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
import Zip

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
    
    static let currentLogFileURL: URL = {
        let fileName: String = String(format: "log_%@", currentTimestamp)
        let finalURL: URL = logFilesDirURL
            .appendingPathComponent(fileName)
            .appendingPathExtension("txt")
        
        return finalURL
    }()
    
    static var doesCurrentLogFileExist: Bool {
        return FileManager.default.fileExists(atPath: currentLogFileURL.path)
    }
    
    static var logFilesDirURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Logs")
    }
    
    static var contentsOfLogFilesDir: [URL] {
        do {
            return try FileManager.default.contentsOfDirectory(at: logFilesDirURL,
                                                               includingPropertiesForKeys: [.creationDateKey],
                                                               options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
                .sorted(by: { url1, url2 in
                    do {
                        guard let date1: Date = try url1.resourceValues(forKeys: [.creationDateKey]).creationDate,
                              let date2: Date = try url2.resourceValues(forKeys: [.creationDateKey]).creationDate else {
                            return false
                        }
                        return date1 < date2
                    } catch {
                        NSLog(error.localizedDescription)
                        return false
                    }
                })
        } catch {
            NSLog(error.localizedDescription)
            return []
        }
    }
    
    private typealias _Log = SwiftyBeaver
    private static let fileDestination: FileDestination = .init(logFileURL: currentLogFileURL)
    private static let consoleDestination: ConsoleDestination = .init()
    
    private static var didSetup: Bool = false
    
    private static var currentTimestamp: String {
        let date: Date = .init()
        let formatter: DateFormatter = .init()
        formatter.dateFormat = "YYMMDD_HHmmss"
        return formatter.string(from: date)
    }
    private static let maxLogFilesCount: Int = 2
    
    private static let logArchivesDirURL: URL = {
        logFilesDirURL
            .appendingPathComponent("Archives")
    }()
    
    static func archiveAllLogFiles() -> Observable<URL> {
        return .create { observable in
            var isDirectory: ObjCBool = true
            var doesExist: Bool = FileManager.default.fileExists(atPath: logArchivesDirURL.path, isDirectory: &isDirectory)
            
            if !isDirectory.boolValue && doesExist {
                do {
                    try FileManager.default.removeItem(at: logArchivesDirURL)
                    doesExist = false
                } catch {
                    observable.onError(error)
                    return Disposables.create()
                }
            }
            
            if !doesExist {
                do {
                    try FileManager.default.createDirectory(at: logArchivesDirURL, withIntermediateDirectories: false, attributes: nil)
                } catch {
                    observable.onError(error)
                    return Disposables.create()
                }
            }
            
            let fileName: String = String(format: "archive_logs_%@", currentTimestamp)
            let finalURL: URL = logArchivesDirURL
                .appendingPathComponent(fileName)
                .appendingPathExtension("zip")
            let files: [URL] = contentsOfLogFilesDir
            
            guard files.count > 0 else {
                observable.onError(LogError.exportNoLogFiles)
                return Disposables.create()
            }
            
            NSLog(finalURL.path)
            
            do {
                try Zip.zipFiles(paths: files, zipFilePath: finalURL, password: nil, progress: nil)
                observable.onNext(finalURL)
                observable.onCompleted()
            } catch {
                observable.onError(error)
            }
            
            return Disposables.create()
        }
        .subscribe(on: SerialDispatchQueueScheduler(qos: .userInitiated))
    }
    
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
    
    private static func initialize() {
        guard !didSetup else {
            return
        }
        
        cleanUpIfNeeded()
        
        if isEnabledSaveToFile {
            _Log.addDestination(fileDestination)
        }
        _Log.addDestination(consoleDestination)
        
        didSetup = true
    }
    
    private static func cleanUpIfNeeded() {
        let logFiles: [URL] = contentsOfLogFilesDir
        
        guard let firstLogFile: URL = logFiles.first,
            (logFiles.count >= maxLogFilesCount) else {
            return
        }
        
        do {
            try FileManager.default.removeItem(at: firstLogFile)
            
            // recursive
            cleanUpIfNeeded()
        } catch {
            NSLog(error.localizedDescription)
        }
    }
}
