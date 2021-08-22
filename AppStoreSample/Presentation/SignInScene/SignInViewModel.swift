//
//  SignInViewModel.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/19.
//

import RxSwift
import RxCocoa
import RxFlow

final class SignInViewModel: ViewModelType, Stepper {
    struct Input {
        let signInButtonTapped: PublishRelay<Void> = .init()
    }
    
    struct Output {
        let signInSuccess: Driver<Bool>
    }
    
    lazy var input: Input = .init()
    lazy var output: Output = mutate(input: input)
    
    var steps: PublishRelay<Step> = .init()
    
    private let disposeBag: DisposeBag = .init()
    
    func mutate(input: Input) -> Output {
        let signedIn = input.signInButtonTapped
            .map { true }
            .asDriver(onErrorJustReturn: false)
        
        input.signInButtonTapped
            .map { _ in AppStep.didSignIn }
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        return Output(signInSuccess: signedIn)
    }
}
