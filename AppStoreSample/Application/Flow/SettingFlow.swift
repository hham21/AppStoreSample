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
    private let diContainer: SettingSceneDIContainer

    
    init(stepper: SettingStepper, diContainer: SettingSceneDIContainer) {
        self.stepper = stepper
        self.diContainer = diContainer
        self.rootViewController = diContainer.makeSettingSceneRootController()
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
        default:
            return .none
        }
    }
    
    private func coordinateToSettingVC() -> FlowContributors {
        let settingVC: SettingViewController = SettingViewController.instantiate()
        let contributor: FlowContributor = .contribute(withNextPresentable: settingVC, withNextStepper: settingVC.viewModel)
        rootViewController.setViewControllers([settingVC], animated: true)
        return .one(flowContributor: contributor)
    }
}
