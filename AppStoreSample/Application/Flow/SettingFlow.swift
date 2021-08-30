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
    
    let stepper: SettingStepper
    
    private let rootViewController: UINavigationController
    
    init(stepper: SettingStepper) {
        self.stepper = stepper
        self.rootViewController = .init()
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else {
            return .none
        }
        
        switch step {
        case .settingMain:
            return coordinateToSettingVC()
        case .signedOut:
            return .end(forwardToParentFlowWithStep: AppStep.signedOut)
        case .pushToInternal:
            return coordinateToInternalVC()
        default:
            return .none
        }
    }
    
    private func coordinateToSettingVC() -> FlowContributors {
        let settingVC: SettingMainViewController = DIContainer.resolve(SettingMainViewController.self)!
        let contributor: FlowContributor = .contribute(withNextPresentable: settingVC, withNextStepper: settingVC.viewModel)
        rootViewController.setViewControllers([settingVC], animated: true)
        settingVC.loadViewIfNeeded()
        return .one(flowContributor: contributor)
    }
    
    private func coordinateToInternalVC() -> FlowContributors {
        let stepper: InternalStepper = .init()
        let flow: InternalFlow = .init(stepper: stepper)
        
        Flows.use(flow, when: .created) { [weak self] root in
            self?.rootViewController.pushViewController(root, animated: true)
        }
        
        return .one(flowContributor: .contribute(withNextPresentable: flow, withNextStepper: stepper))
    }
}
