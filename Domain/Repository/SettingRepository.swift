//
//  SettingRepository.swift
//  Domain
//
//  Created by Jinwoo Kim on 8/25/21.
//

import RxSwift

public protocol SettingRepository {
    func getSetting() -> Single<Setting>
    func saveSetting(_ setting: Setting) -> Completable
    func observeSetting() -> Observable<Void>
}
