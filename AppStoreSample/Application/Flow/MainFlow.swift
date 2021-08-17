//
//  MainFlow.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/02.
//

import RxSwift
import RxFlow
import UIKit

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
    
    let appDIContainer: AppDIContainer
    let rootViewController: UITabBarController
    
    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
        self.rootViewController = appDIContainer.makeRootViewController()
        self.searchFlow = appDIContainer.makeSearchFlow()
        self.settingFlow = appDIContainer.makeSettingFlow()
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else {
            return .none
        }
        
        switch step {
        case .tapBarMain:
            return coordinateToMainTapBar()
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
