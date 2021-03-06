//
//  AppFlow.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/02.
//

import Domain
import UIKit
import RxSwift
import RxCocoa
import RxFlow

enum AppStep: Step {
    case initial
    
    // SignIn
    case signedOut
    case didSignIn
    
    // Main
    case mainRequired
    
    // Search
    case searchMain
    case searchResult
    case searchDetail(track: Track)
    
    // Setting
    case settingMain
    case pushToInternal
}

struct AppStepper: Stepper {
    internal let steps: PublishRelay<Step> = .init()
    
    private let disposeBag: DisposeBag = .init()
    
    init() {
    }
    
    func readyToEmitSteps() {
        Observable.just(AppStep.signedOut)
            .bind(to: steps)
            .disposed(by: disposeBag)
    }
}

final class AppFlow: Flow {
    private let rootWindow: UIWindow
    
    var root: Presentable {
        return rootWindow
    }
    
    init(with rootWindow: UIWindow) {
        self.rootWindow = rootWindow
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else {
            return .none
        }
        
        switch step {
        case .signedOut:
            return coordinateToSignInVC()
        case .mainRequired:
            return coordinateToMainVC()
        default:
            return .none
        }
    }
    
    private func coordinateToSignInVC() -> FlowContributors {
        let signInFlow: SignInFlow = DIContainer.resolve(SignInFlow.self)!
        
        Flows.use(signInFlow, when: .created) { [unowned self] rootVC in
            self.rootWindow.rootViewController = rootVC
        }
        
        let stepper: OneStepper = .init(withSingleStep: AppStep.signedOut)
        let contributor: FlowContributor = .contribute(withNextPresentable: signInFlow, withNextStepper: stepper)
        return .one(flowContributor: contributor)
    }
    
    private func coordinateToMainVC() -> FlowContributors {
        let mainFlow: MainFlow = DIContainer.resolve(MainFlow.self)!
        
        Flows.use(mainFlow, when: .created) { [unowned self] root in
            rootWindow.rootViewController = root
        }
        
        let stepper: OneStepper = .init(withSingleStep: AppStep.mainRequired)
        let contributor: FlowContributor = .contribute(withNextPresentable: mainFlow, withNextStepper: stepper)
        return .one(flowContributor: contributor)
    }
}
