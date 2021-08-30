//
//  SettingUseCase.swift
//  Domain
//
//  Created by Jinwoo Kim on 8/25/21.
//

import RxSwift

public protocol SettingUseCase {
    func getSetting() -> Observable<Setting>
    func saveSetting(_ setting: Setting) -> Observable<Void>
    func observeSetting() -> Observable<Void>
}

public struct SettingUseCaseImpl: SettingUseCase {
    private let repo: SettingRepository
    
    public init(repo: SettingRepository) {
        self.repo = repo
    }
    
    public func getSetting() -> Observable<Setting> {
        repo.getSetting()
    }
    
    public func saveSetting(_ setting: Setting) -> Observable<Void> {
        repo.saveSetting(setting)
    }
    
    public func observeSetting() -> Observable<Void> {
        repo.observeSetting()
    }
}
