//
//  SearchFlow.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/02.
//

import UIKit
import RxSwift
import RxCocoa
import RxFlow

struct SearchStepper: Stepper {
    let steps: PublishRelay<Step> = .init()
    
    var initialStep: Step {
        return AppStep.search
    }
}

final class SearchFlow: Flow {
    var root: Presentable {
        return rootViewController
    }
    
    private let rootViewController = UINavigationController()
    
    let stepper: SearchStepper
    
    init(stepper: SearchStepper) {
        self.stepper = stepper
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else {
            return .none
        }
        
        switch step {
        case .search:
            return coordinateToTestVC()
        default:
            return .none
        }
    }
    
    private func coordinateToTestVC() -> FlowContributors {
        let vc: UIViewController = .init()
        vc.view.backgroundColor = .brown
        rootViewController.setViewControllers([vc], animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: SearchStepper()))
    }
}



