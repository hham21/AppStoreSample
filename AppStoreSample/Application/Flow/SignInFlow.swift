//
//  SignInFlow.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/19.
//

import RxFlow

final class SignInFlow: Flow {
    var root: Presentable {
        return rootViewController
    }
    
    private let diContainer: SignInSceneDIContainer
    private let rootViewController: UINavigationController
    
    init(diContainer: SignInSceneDIContainer) {
        self.diContainer = diContainer
        self.rootViewController = diContainer.makeSignInRootViewController()
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else {
            return .none
        }
        
        switch step {
        case .signedOut:
            return coordinateToSignIn()
        case .didSignIn:
            return .end(forwardToParentFlowWithStep: AppStep.mainRequired)
        default:
            return .none
        }
    }
    
    private func coordinateToSignIn() -> FlowContributors {
        let vc: SignInViewController = diContainer.makeSignInViewController()
        let contributor: FlowContributor = .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel)
        rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: contributor)
    }
}
