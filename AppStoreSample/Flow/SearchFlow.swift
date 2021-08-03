//
//  SearchFlow.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/02.
//

import Domain
import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Reusable
import Data

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

    let stepper: SearchStepper
    
    private let rootViewController = UINavigationController()
    private let service: KeywordUseCaseProvider = KeywordUseCaseProviderImpl()
    
    init(stepper: SearchStepper) {
        self.stepper = stepper
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else {
            return .none
        }
        
        switch step {
        case .searchMain:
            return coordinateToSearchMainVC()
        default:
            return .none
        }
    }
    
    private func coordinateToSearchMainVC() -> FlowContributors {
        let useCase: KeywordUseCase = service.createKeywordUseCase()
        let viewModel: SearchMainViewModel = .init(keywordUseCase: useCase)
        let viewController: SearchMainViewController = .create(with: viewModel)
        rootViewController.setViewControllers([viewController], animated: true)
        return .none
    }
}



