//
//  AppDIContainer.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/16.
//

import UIKit
import Domain
import Data

final class AppDIContainer {
    
    // MARK: - Scene
    
    func makeSignInSceneDIContainer() -> SignInSceneDIContainer {
        return SignInSceneDIContainer()
    }
    
    func makeSearchSceneDIContainer() -> SearchSceneDIContainer {
        return SearchSceneDIContainer()
    }
    
    func makeSettingSceneDIContainer() -> SettingSceneDIContainer {
        return SettingSceneDIContainer()
    }
    
    // MARK: - ViewController
    
    func makeRootViewController() -> UITabBarController {
        return .init()
    }
    
    // MARK: - Flow
    
    func makeSearchFlow() -> SearchFlow {
        return SearchFlow(
            stepper: makeSearchStepper(),
            diContainer: makeSearchSceneDIContainer()
        )
    }
    
    func makeSettingFlow() -> SettingFlow {
        return SettingFlow(
            stepper: .init(),
            diContainer: makeSettingSceneDIContainer()
        )
    }
    
    // MARK: - Stepper
    
    func makeSearchStepper() -> SearchStepper {
        return .init()
    }
    
    // MARK: - Service
    
    func makeAuthService() -> AuthService {
        return AuthServiceImpl()
    }
}
