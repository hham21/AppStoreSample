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
        coordinateToTestVC()
    }
    
    private func coordinateToTestVC() -> FlowContributors {
        let settingVC: SettingViewController = SettingViewController.instantiate()
        rootViewController.setViewControllers([settingVC], animated: true)
//        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: SearchStepper()))
        return .none
    }
}
