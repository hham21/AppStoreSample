//
//  SettingDataSource.swift
//  Data
//
//  Created by Jinwoo Kim on 8/25/21.
//

import Domain
import RxSwift

public protocol SettingDataSource {
    func getSetting() -> Observable<Setting>
    func saveSetting(_ setting: Setting) -> Observable<Void>
    func observeSetting() -> Observable<Void>
}
