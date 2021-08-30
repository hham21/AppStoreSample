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
