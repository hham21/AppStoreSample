//
//  InternalFlow.swift
//  AppStoreSample
//
//  Created by Jinwoo Kim on 8/30/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxFlow

struct InternalStepper: Stepper {
    let steps: PublishRelay<Step> = .init()
}

final class InternalFlow: Flow {
    var root: Presentable {
        rootViewController
    }
    
    let stepper: InternalStepper
    
    private let rootViewController: InternalMainViewController
    
    init(stepper: InternalStepper) {
        self.stepper = stepper
        self.rootViewController = DIContainer.resolve(InternalMainViewController.self)!
    }
    
    func navigate(to step: Step) -> FlowContributors {
        .none
    }
}
