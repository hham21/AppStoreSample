//
//  SettingFlow.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/02.
//

import UIKit
import RxSwift
import RxCocoa
import RxFlow

struct SettingStepper: Stepper {
    let steps: PublishRelay<Step> = .init()
    
    var initialStep: Step {
        return AppStep.settingMain
    }
}

final class SettingFlow: Flow {
    var root: Presentable {
        return rootViewController
    }
    
    private let rootViewController = UINavigationController()

    let stepper: SettingStepper
    
    init(stepper: SettingStepper) {
        self.stepper = stepper
    }
    
    func navigate(to step: Step) -> FlowContributors {
        coordinateToTestVC()
    }
    
    private func coordinateToTestVC() -> FlowContributors {
        let vc: UIViewController = .init()
        vc.view.backgroundColor = .blue
        rootViewController.setViewControllers([vc], animated: true)
//        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: SearchStepper()))
        return .none
    }
}
