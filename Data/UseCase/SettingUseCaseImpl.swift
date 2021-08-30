//
//  SettingUseCaseImpl.swift
//  Data
//
//  Created by Jinwoo Kim on 8/25/21.
//

import Domain
import RxSwift

public struct SettingUseCaseImpl: SettingUseCase {
    private let repo: SettingRepository
    
    public init(repo: SettingRepository) {
        self.repo = repo
    }
    
    public func getSetting() -> Single<Setting> {
        repo.getSetting()
    }
    
    public func saveSetting(_ setting: Setting) -> Completable {
        repo.saveSetting(setting)
    }
    
    public func observeSetting() -> Observable<Void> {
        repo.observeSetting()
    }
}
