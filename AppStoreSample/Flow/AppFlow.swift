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
    
    // TapBar
    case tapBarMain
    
    // Search
    case searchMain
    case searchResult
    case searchDetail(track: Track)
    
    // Setting
    case settingMain
}

struct AppStepper: Stepper {
    let steps: PublishRelay<Step> = .init()
    private let disposeBag: DisposeBag = .init()
    
    init() {}
    
    func readyToEmitSteps() {
        // 로그인 없이 바로 시작
        Observable.just(AppStep.initial)
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
        case .initial:
            return coordinatorToMainVC()
        default:
            return .none
        }
    }
    
    private func coordinatorToMainVC() -> FlowContributors {
        let mainFlow: MainFlow = .init()
        
        Flows.use(mainFlow, when: .created) { [unowned self] root in
            rootWindow.rootViewController = root
        }
        
        let stepper: OneStepper = .init(withSingleStep: AppStep.tapBarMain)
        let contributor: FlowContributor = .contribute(withNextPresentable: mainFlow, withNextStepper: stepper)
        return .one(flowContributor: contributor)
    }
}
