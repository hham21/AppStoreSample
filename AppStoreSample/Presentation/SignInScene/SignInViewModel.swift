//
//  SignInViewModel.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/19.
//

import RxSwift
import RxCocoa
import RxFlow

final class SignInViewModel: ViewModelWithStepper {
    enum Input {
        case signInButtonTapped
    }
    
    struct Output {
        var didSignIn: Bool?
    }
    
    var input: PublishRelay<Input> = .init()
    var output: BehaviorRelay<Output> = .init(value: .init())
    
    let disposeBag: DisposeBag = .init()
    let steps: PublishRelay<Step> = .init()
    
    init() {
        bind()
    }
    
    func reduce(mutation: Input) -> Observable<Output> {
        switch mutation {
        case .signInButtonTapped:
            return .just(.init(didSignIn: true))
        }
    }
    
    func coordinate(input: Input) -> Observable<Step> {
        switch input {
        case .signInButtonTapped:
            return .just(AppStep.didSignIn)
        }
    }
}
