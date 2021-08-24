//
//  MainFlow.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/02.
//

import UIKit
import RxSwift
import RxFlow

final class MainFlow: Flow {
    enum Tab: Int {
        case search = 0
        case setting = 1
    }
    
    private let searchFlow: SearchFlow
    private let settingFlow: SettingFlow
    
    var root: Presentable {
        return rootViewController
    }
    
    let rootViewController: UITabBarController = .init()
    
    init(searchFlow: SearchFlow, settingFlow: SettingFlow) {
        self.searchFlow = searchFlow
        self.settingFlow = settingFlow
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else {
            return .none
        }
        
        switch step {
        case .mainRequired:
            return coordinateToMainTapBar()
        case .signedOut:
            return .end(forwardToParentFlowWithStep: AppStep.signedOut)
        default:
            return .none
        }
    }
    
    private func coordinateToMainTapBar() -> FlowContributors {
        Flows.use(
            searchFlow, settingFlow,
            when: .created
        ) { [unowned self] (search: UINavigationController,
                            setting: UINavigationController) in
            
            self.rootViewController.setViewControllers([search, setting], animated: true)
        }
        
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: searchFlow, withNextStepper: searchFlow.stepper),
            .contribute(withNextPresentable: settingFlow, withNextStepper: settingFlow.stepper)
        ])
    }
}
