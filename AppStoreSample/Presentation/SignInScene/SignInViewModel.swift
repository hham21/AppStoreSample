//
//  SignInViewModel.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/19.
//

import RxSwift
import RxCocoa
import RxFlow
import ReactorKit

final class SignInViewModel: Reactor, Stepper {
    enum Action {
        case signInButtonTapped
    }
    
    struct State {
        var didSignIn: Bool = false
    }
    
    let steps: PublishRelay<Step> = .init()
    let initialState: State = .init()
    let disposeBag: DisposeBag = .init()
    
    init() {}
    
    func mutate(action: Action) -> Observable<Action> {
        switch action {
        case .signInButtonTapped:
            steps.accept(AppStep.didSignIn)
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Action) -> State {
        var newState = state
        switch mutation {
        case .signInButtonTapped:
            newState.didSignIn = true
        }
        return newState
    }
}
