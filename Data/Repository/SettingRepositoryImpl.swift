//
//  SettingRepositoryImpl.swift
//  Data
//
//  Created by Jinwoo Kim on 8/25/21.
//

import Domain
import RxSwift

public struct SettingRepositoryImpl: SettingRepository {
    private let settingDataSource: SettingDataSource
    
    public init(settingDataSource: SettingDataSource) {
        self.settingDataSource = settingDataSource
    }
    
    public func getSetting() -> Observable<Setting> {
        settingDataSource.getSetting()
    }
    
    public func saveSetting(_ setting: Setting) -> Observable<Void> {
        settingDataSource.saveSetting(setting)
    }
    
    public func observeSetting() -> Observable<Void> {
        settingDataSource.observeSetting()
    }
}
