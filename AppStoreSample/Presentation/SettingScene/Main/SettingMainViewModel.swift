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

final class SettingMainViewModel: ViewModelType, Stepper {
    struct Input {
        let initialLoad: PublishRelay<Void> = .init()
        let pushTapped: PublishRelay<SettingMain.Destination> = .init()
        let signOutTapped: PublishRelay<Void> = .init()
        let shakeDetected: PublishRelay<Void> = .init()
    }
    
    struct Output {
        let signedOut: PublishRelay<Void> = .init()
        let dataSource: Driver<[SettingMain.Model]>
    }
    
    lazy var input: Input = .init()
    lazy var output: Output = mutate(input: input)
    var steps: PublishRelay<Step> = .init()
    
    private let settingUseCase: SettingUseCase
    private let disposeBag: DisposeBag = .init()
    
    init(settingUseCase: SettingUseCase) {
        self.settingUseCase = settingUseCase
    }
    
    func mutate(input: Input) -> Output {
        let dataSourceRelay: BehaviorRelay<[SettingMain.Model]> = .init(value: [])
        
        let dataSourceDriver: Driver<[SettingMain.Model]> = dataSourceRelay
            .asDriver(onErrorJustReturn: [])
        
        settingUseCase
            .observeSetting()
            .startWith(())
            .withUnretained(self)
            .map { $0.0 }
            .flatMap { $0.settingUseCase.getSetting() }
            .map { SettingMain().buildModel($0) }
            .do(onNext: { JBLog.print(.debug($0)) })
            .bind(to: dataSourceRelay)
            .disposed(by: disposeBag)
        
        let output: Output = .init(dataSource: dataSourceDriver)
        
        input.signOutTapped
            .bind(to: output.signedOut)
            .disposed(by: disposeBag)
        
        input.signOutTapped
            .map { _ in AppStep.signedOut }
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        input.shakeDetected
            .withUnretained(self)
            .map { $0.0 }
            .flatMap { $0.settingUseCase.saveSetting(.init(isInternalMode: true)) }
            .subscribe()
            .disposed(by: disposeBag)
        
        return output
    }
}
