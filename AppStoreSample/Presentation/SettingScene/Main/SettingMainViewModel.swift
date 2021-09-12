//
//  SettingMainViewModel.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/20.
//

import Domain
import RxSwift
import RxCocoa
import RxFlow
import ReactorKit

final class SettingMainViewModel: Reactor, Stepper {
    enum Action {
        case initialLoad
        case observeSetting
        case signOutTapped
        case shakeDetected
        case didSelectInternal
    }
    
    enum Mutation {
        case getSetting(Setting)
        case signedOut
        case settingSaved
        case error(Error)
    }
    
    struct State {
        var dataSource: [SettingMain.Model] = []
        var signedOut: Bool?
    }
    
    let initialState: State = .init()
    let steps: PublishRelay<Step> = .init()
    
    private let settingUseCase: SettingUseCase
    
    let disposeBag: DisposeBag = .init()
    
    init(settingUseCase: SettingUseCase) {
        self.settingUseCase = settingUseCase
        action.onNext(.observeSetting)
        action.onNext(.initialLoad)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .observeSetting:
            return settingUseCase.observeSetting()
                .withUnretained(self)
                .map { $0.0 }
                .flatMap { $0.settingUseCase.getSetting() }
                .map { .getSetting($0) }
                .do(onNext: { log.debug($0) })
        case .initialLoad:
            return settingUseCase.getSetting()
                .map { .getSetting($0) }
        case .shakeDetected:
             return settingUseCase.saveSetting(.init(isInternalMode: true))
                .map { .settingSaved }
                .catch { .just(.error($0)) }
        case .signOutTapped:
            steps.accept(AppStep.signedOut)
            return .just(.signedOut)
        case .didSelectInternal:
            steps.accept(AppStep.pushToInternal)
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .getSetting(let setting):
            let dataSource: [SettingMain.Model] = SettingMain().buildModel(setting)
            newState.dataSource = dataSource
        case .settingSaved:
            log.debug("setting saved")
        case .signedOut:
            newState.signedOut = true
        case .error(let error):
            log.error(error)
        }
        
        return newState
    }
}
