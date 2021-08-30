//
//  InternalMainViewModel.swift
//  AppStoreSample
//
//  Created by Jinwoo Kim on 8/30/21.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import RxFlow

final class InternalMainViewModel: ViewModelType, Stepper {
    struct Input {
        let changeLoggingToFileEnabled: BehaviorRelay<Bool> = .init(value: JBLog.isEnabledSaveToFile)
        let requestLogFileUrl: PublishRelay<Void> = .init()
    }
    
    struct Output {
        let dataSource: Driver<[InternalMain.Model]>
        let requestedLogFileUrl: PublishRelay<URL>
        let errorOccured: Signal<Error>
    }
    
    lazy var input: Input = .init()
    lazy var output: Output = mutate(input: input)
    
    var steps: PublishRelay<Step> = .init()
    
    private let disposeBag: DisposeBag = .init()
    
    func mutate(input: Input) -> Output {
        let dataSourceRelay: BehaviorRelay<[InternalMain.Model]> = .init(value: [.init(model: .first, items: [.shareLogFile])])
        let dataSourceDriver: Driver<[InternalMain.Model]> = dataSourceRelay
            .asDriver(onErrorJustReturn: [])
        let requestedLogFileUrl: PublishRelay<URL> = .init()
        let errorRelay: PublishRelay<Error> = .init()
        
        //
        
        input.changeLoggingToFileEnabled
            .withUnretained(dataSourceRelay)
            .filter { $0.0.value.count > 0 }
            .map { (weakRelay, isEnabled) -> [InternalMain.Model] in
                var data: [InternalMain.Model] = weakRelay.value
                
                data[0].items.removeAll { item in
                    switch item {
                    case .isLoggingToFileEnabled(_):
                        return true
                    default:
                        return false
                    }
                }
                
                data[0].items.append(.isLoggingToFileEnabled(isEnabled))
                
                JBLog.isEnabledSaveToFile = isEnabled
                
                return data
            }
            .bind(to: dataSourceRelay)
            .disposed(by: disposeBag)
        
        //
        
        input.requestLogFileUrl
            .filter { _ in
                guard JBLog.doesLogFileExists else {
                    errorRelay.accept(InternalMainError.noLogFile)
                    return false
                }
                return true
            }
            .map { _ in JBLog.logFileURL }
            .bind(to: requestedLogFileUrl)
            .disposed(by: disposeBag)
        
        //
        
        let output = Output(dataSource: dataSourceDriver, requestedLogFileUrl: requestedLogFileUrl, errorOccured: errorRelay.asSignal())
        
        return output
    }
}
