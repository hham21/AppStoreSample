//
//  SettingMainViewModel.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/20.
//

import RxSwift
import RxCocoa
import RxFlow
import Domain

final class SettingMainViewModel: ViewModelWithStepper {
    enum Input {
        case initialLoad
        case observeSetting
        case pushTapped(SettingMain.Destination)
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
    
    struct Output {
        var signedOut: Bool?
        var dataSource: [SettingMain.Model] = []
    }
    
    let input: PublishRelay<Input> = .init()
    let mutation: PublishRelay<Mutation> = .init()
    let output: BehaviorRelay<Output> = .init(value: .init())
    
    private let settingUseCase: SettingUseCase
    
    let steps: PublishRelay<Step> = .init()
    let disposeBag: DisposeBag = .init()
    
    init(settingUseCase: SettingUseCase) {
        self.settingUseCase = settingUseCase
        bind()
        input.accept(.observeSetting)
        input.accept(.initialLoad)
    }
    
    func mutate(input: Input) -> Observable<Mutation> {
        switch input {
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
        case .signOutTapped:
            return .just(.signedOut)
        case .shakeDetected:
             return settingUseCase.saveSetting(.init(isInternalMode: true))
                .map { .settingSaved }
                .catch { .just(.error($0)) }
        default:
            return .empty()
        }
    }
    
    func reduce(mutation: Mutation) -> Observable<Output> {
        var newOutput = output.value
        
        switch mutation {
        case .getSetting(let setting):
            let dataSource: [SettingMain.Model] = SettingMain().buildModel(setting)
            newOutput.dataSource = dataSource
        case .settingSaved:
            log.debug("setting saved")
        case .signedOut:
            newOutput.signedOut = true
        case .error(let error):
            log.error(error)
        }
        
        return .just(newOutput)
    }
    
    func coordinate(input: Input) -> Observable<Step> {
        switch input {
        case .signOutTapped:
            return .just(AppStep.signedOut)
        case .didSelectInternal:
            return .just(AppStep.pushToInternal)
        default:
            return .empty()
        }
    }
}


//final class SettingMainViewModel: Stepper {
//    struct Input {
//        let initialLoad: PublishRelay<Void> = .init()
//        let pushTapped: PublishRelay<SettingMain.Destination> = .init()
//        let signOutTapped: PublishRelay<Void> = .init()
//        let shakeDetected: PublishRelay<Void> = .init()
//    }
//
//    struct Output {
//        let signedOut: PublishRelay<Void> = .init()
//        let dataSource: Driver<[SettingMain.Model]>
//    }
//
//    lazy var input: Input = .init()
//    lazy var output: Output = mutate(input: input)
//    var steps: PublishRelay<Step> = .init()
//
//    private let settingUseCase: SettingUseCase
//    private let disposeBag: DisposeBag = .init()
//
//    init(settingUseCase: SettingUseCase) {
//        self.settingUseCase = settingUseCase
//    }
//
//    func mutate(input: Input) -> Output {
//        let dataSourceRelay: BehaviorRelay<[SettingMain.Model]> = .init(value: [])
//
//        let dataSourceDriver: Driver<[SettingMain.Model]> = dataSourceRelay
//            .asDriver(onErrorJustReturn: [])
//
//        settingUseCase
//            .observeSetting()
//            .startWith(())
//            .withUnretained(self)
//            .map { $0.0 }
//            .flatMap { $0.settingUseCase.getSetting() }
//            .map { SettingMain().buildModel($0) }
//            .do(onNext: { log.debug($0) })
//            .bind(to: dataSourceRelay)
//            .disposed(by: disposeBag)
//
//        let output: Output = .init(dataSource: dataSourceDriver)
//
//        input.signOutTapped
//            .bind(to: output.signedOut)
//            .disposed(by: disposeBag)
//
//        input.signOutTapped
//            .map { _ in AppStep.signedOut }
//            .bind(to: steps)
//            .disposed(by: disposeBag)
//
//        input.shakeDetected
//            .withUnretained(self)
//            .map { $0.0 }
//            .flatMap { $0.settingUseCase.saveSetting(.init(isInternalMode: true)) }
//            .subscribe()
//            .disposed(by: disposeBag)
//
//        return output
//    }
//}
