//
//  Log.swift
//  AppStoreSample
//
//  Created by Jinwoo Kim on 9/6/21.
//

import Foundation
import RxSwift
import RxCocoa

/// 로그 형식과 데이터이다.
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

/// 로그 관련 에러
enum LogError: Error {
    case exportNoLogFiles
}

protocol Log {
    // MARK: - 로그 파일
    
    /// 파일로 저장할지 말지를 설정한다. 비활성화해도 파일은 유지되어야 한다.
    static var isEnabledSaveToFile: Bool { get set }
    
    /// 현재 작업 중인 로그 파일의 URL이다. 로그가 하나도 안 썼을 경우, 파일이 존재하지 않을 수 있다.
    static var currentLogFileURL: URL { get }
    
    /// currentLogFileURL이 존재하는지 알려준다.
    static var doesCurrentLogFileExist: Bool { get }
    
    /// 로그 파일이 모인 폴더이다. 로그가 하나도 없거나, 권한 문제로 작성에 실패했을 경우 존재하지 않을 수 있다.
    static var logFilesDirURL: URL { get }
    
    /// 로그 파일들의 목록이다. UNIX Creation Date에 따라 sort 된다.
    static var contentsOfLogFilesDir: [URL] { get }
    
    /// 로그 파일들을 모두 ZIP 파일로 압축한다. dispose가 될 경우 압축된 파일은 삭제된다.
    static func archiveAllLogFiles() -> Observable<URL>
    
    // MARK: - 로그 발생
    
    /// 로그가 전송될 때마다 이벤트가 날라온다.
    static var triggeredLog: PublishRelay<LogData> { get }
    
    /// 발생 시 정상작동에 문제가 생기는 경우
    ///
    /// 완전한 핸들링 불가능한 에러 케이스, 발생하면 안되는 분기
    static func error(_ message: Any, file: String, function: String, line: Int)
    
    /// 발생 시 정상작동에는 문제없는 예외적 상황
    ///
    /// 완전한 핸들링 가능한 에러 케이스, 단순히 예상못한 분기
    static func warning(_ message: Any, file: String, function: String, line: Int)
    
    /// 시스템의 일반 상태. CLI처럼 GUI를 텍스트로 대신한다고 생각하면 들어가야 할 내용들을 기입. 전체 내용을 쭉 읽을 수 있는 분량으로 감안
    ///
    /// 사용자 액션 (이벤트 로그 연계), 화면 전환 (이벤트 로그 연계), 주요 동작의 시작과 끝 (이벤트 로그 연계), 표시/업데이트된 데이터 내용
    static func info(_ message: Any, file: String, function: String, line: Int)
    
    /// 시스템의 세부 상태. Human-Readable하긴 하지만 디버깅 시에만 필요한 세부 사항. 분량이 많아 주로 검색/필터링을 통해 볼 것으로 감안
    ///
    /// 주요 동작의 중간과정, 데이터의 세부 필드
    static func debug(_ message: Any, file: String, function: String, line: Int)
    
    /// 특정 동작의 모든 중간 과정. 코드와 콘솔 창의 가독성을 해칠 정도의 세부 사항. 다른 팀원에게 보이지 않도록 PR 시 삭제 또는 주석 처리
    ///
    /// 주요 동작의 모든 중간 함수 호출, 매 프레임별 정보, 주요하지 않은 동작, 도메인 의미가 없는 로컬 변수
    static func verbose(_ message: Any, file: String, function: String, line: Int)
}

extension Log {
    static func error(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        Self.error(message, file: file, function: function, line: line)
    }
    
    static func warning(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        Self.warning(message, file: file, function: function, line: line)
    }
    
    static func info(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        Self.info(message, file: file, function: function, line: line)
    }
    
    static func debug(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        Self.debug(message, file: file, function: function, line: line)
    }
    
    static func verbose(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        Self.verbose(message, file: file, function: function, line: line)
    }
}
