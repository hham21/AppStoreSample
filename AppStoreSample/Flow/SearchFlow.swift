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
import Reusable

struct SearchStepper: Stepper {
    let steps: PublishRelay<Step> = .init()
    
    var initialStep: Step {
        return AppStep.searchMain
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
        case .searchMain:
            return coordinateToTestVC()
        default:
            return .none
        }
    }
    
    private func coordinateToTestVC() -> FlowContributors {
        let vc: SearchMainViewController = SearchMainViewController.instantiate()
        rootViewController.setViewControllers([vc], animated: true)
        return .none
    }
}



