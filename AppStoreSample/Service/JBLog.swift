//
//  JBLog.swift
//  AppStoreSample
//
//  Created by Jinwoo Kim on 8/30/21.
//

import Foundation
import SwiftyBeaver
import RxSwift
import RxCocoa

final class JBLog {
    
    enum LogData {
        
        /// 발생 시 정상작동에 문제가 생기는 경우
        ///
        /// 완전한 핸들링 불가능한 에러 케이스, 발생하면 안되는 분기
        case error(Any)
        
        /// 발생 시 정상작동에는 문제없는 예외적 상황
        ///
        /// 완전한 핸들링 가능한 에러 케이스, 단순히 예상못한 분기
        case warning(Any)
        
        /// 시스템의 일반 상태. CLI처럼 GUI를 텍스트로 대신한다고 생각하면 들어가야 할 내용들을 기입. 전체 내용을 쭉 읽을 수 있는 분량으로 감안
        ///
        /// 사용자 액션 (이벤트 로그 연계), 화면 전환 (이벤트 로그 연계), 주요 동작의 시작과 끝 (이벤트 로그 연계), 표시/업데이트된 데이터 내용
        case info(Any)
        
        /// 시스템의 세부 상태. Human-Readable하긴 하지만 디버깅 시에만 필요한 세부 사항. 분량이 많아 주로 검색/필터링을 통해 볼 것으로 감안
        ///
        /// 주요 동작의 중간과정, 데이터의 세부 필드
        case debug(Any)
        
        /// 특정 동작의 모든 중간 과정. 코드와 콘솔 창의 가독성을 해칠 정도의 세부 사항. 다른 팀원에게 보이지 않도록 PR 시 삭제 또는 주석 처리
        ///
        /// 주요 동작의 모든 중간 함수 호출, 매 프레임별 정보, 주요하지 않은 동작, 도메인 의미가 없는 로컬 변수
        case verbose(Any)
        
    }
    
    static let triggeredLog: PublishRelay<LogData> = .init()
    
    static var isEnabledSaveToFile: Bool = true {
        didSet {
            if isEnabledSaveToFile {
                if !Log.destinations.contains(fileDestination) {
                    Log.addDestination(fileDestination)
                }
            } else {
                Log.removeDestination(fileDestination)
            }
        }
    }
    
    static let logFileURL: URL! = {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Logs")
            .appendingPathComponent("JBLog")
            .appendingPathExtension("txt")
    }()
    
    static var doesLogFileExists: Bool {
        return FileManager.default.fileExists(atPath: logFileURL.path)
    }
    
    private typealias Log = SwiftyBeaver
    private static let fileDestination: FileDestination = .init(logFileURL: logFileURL)
    private static let consoleDestination: ConsoleDestination = .init()
    
    private static var didSetup: Bool = false
    
    static func initialize() {
        guard !didSetup else {
            return
        }
        
        if isEnabledSaveToFile {
            Log.addDestination(fileDestination)
        }
        Log.addDestination(consoleDestination)
        
        didSetup = true
    }
    
    static func print(_ logData: LogData) {
        switch logData {
        case .error(let message):
            Log.error(message)
        case .warning(let message):
            Log.warning(message)
        case .info(let message):
            Log.info(message)
        case .debug(let message):
            Log.debug(message)
        case .verbose(let message):
            Log.verbose(message)
        }
        
        triggeredLog.accept(logData)
    }
}
