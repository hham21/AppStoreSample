//
//  SettingRealmDataSource.swift
//  Data
//
//  Created by Jinwoo Kim on 8/25/21.
//

import Domain
import RxSwift
import RealmSwift

public struct SettingRealmDataSource: SettingDataSource {
    private let DB: RealmDB = .init()
    
    public init() {}
    
    public func getSetting() -> Observable<Setting> {
        DB
            .read(predicate: nil)
            .map { (settings: [RMSetting]) -> Setting in
                guard let last: RMSetting = settings.last else {
                    return .init()
                }
                return last.asDomain()
            }
    }
    
    public func saveSetting(_ setting: Setting) -> Observable<Void> {
        DB
            .deleteAll(type: RMSetting.self)
            .flatMap { _ in
                self.DB.update(object: setting.asRealm())
            }
    }
    
    public func observeSetting() -> Observable<Void> {
        DB
            .observe(type: RMSetting.self)
    }
}
