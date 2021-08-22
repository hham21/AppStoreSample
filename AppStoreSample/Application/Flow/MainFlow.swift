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
    
    let rootViewController: UITabBarController
    
    init() {
        self.rootViewController = .init()
        self.searchFlow = DI.resolve(SearchFlow.self)!
        self.settingFlow = DI.resolve(SettingFlow.self)!
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
            
            let searchImage: UIImage? = nil
            let settingImage: UIImage? = nil
            
            let homeItem: UITabBarItem = .init(title: "Search", image: searchImage, selectedImage: nil)
            let settingItem: UITabBarItem = .init(title: "Setting", image: settingImage, selectedImage: nil)
            
            search.tabBarItem = homeItem
            setting.tabBarItem = settingItem
            
            self.rootViewController.setViewControllers([search, setting], animated: true)
        }
        
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: searchFlow, withNextStepper: searchFlow.stepper),
            .contribute(withNextPresentable: settingFlow, withNextStepper: settingFlow.stepper)
        ])
    }
}
