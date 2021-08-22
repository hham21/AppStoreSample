//
//  SettingViewModel.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/20.
//

import RxSwift
import RxCocoa
import RxFlow

final class SettingViewModel: ViewModelType, Stepper {
    struct Input {
        let signOutTapped: PublishRelay<Void> = .init()
    }
    
    struct Output {
        let signedOut: PublishRelay<Void> = .init()
    }
    
    lazy var input: Input = .init()
    lazy var output: Output = mutate(input: input)
    var steps: PublishRelay<Step> = .init()
    
    private let disposeBag: DisposeBag = .init()
    
    func mutate(input: Input) -> Output {
        let output: Output = .init()
        
        input.signOutTapped
            .bind(to: output.signedOut)
            .disposed(by: disposeBag)
        
        input.signOutTapped
            .map { _ in AppStep.signedOut }
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        return output
    }
}
