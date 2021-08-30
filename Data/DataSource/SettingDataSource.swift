//
//  SettingDataSource.swift
//  Data
//
//  Created by Jinwoo Kim on 8/25/21.
//

import Domain
import RxSwift

public protocol SettingDataSource {
    func getSetting() -> Single<Setting>
    func saveSetting(_ setting: Setting) -> Completable
    func observeSetting() -> Observable<Void>
}
