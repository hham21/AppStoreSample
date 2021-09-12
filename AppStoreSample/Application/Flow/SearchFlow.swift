//
//  SearchFlow.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/02.
//

import UIKit
import Domain
import RxSwift
import RxCocoa
import RxFlow
import Reusable
import Swinject

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
    
    private let rootViewController: UINavigationController
    
    init(stepper: SearchStepper) {
        self.stepper = stepper
        self.rootViewController = UINavigationController()
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else {
            return .none
        }
        
        switch step {
        case .searchMain:
            return coordinateToSearchMainVC()
        case .searchDetail(let track):
            return coordinateToSearchDetailVC(with: track)
        default:
            return .none
        }
    }
    
    private func coordinateToSearchMainVC() -> FlowContributors {
        let searchMainVC: SearchMainViewController = DIContainer.resolve(SearchMainViewController.self)!
        rootViewController.setViewControllers([searchMainVC], animated: true)
        searchMainVC.loadViewIfNeeded()
        return .one(
            flowContributor: .contribute(
                withNextPresentable: searchMainVC,
                withNextStepper: searchMainVC.viewModel
            )
        )
    }
    
    private func coordinateToSearchDetailVC(with track: Track) -> FlowContributors {
        let viewModel: DetailViewModel = DIContainer.resolve(DetailViewModel.self, argument: track)!
        let detailVC: SearchDetailViewController = DIContainer.resolve(SearchDetailViewController.self)!
        detailVC.viewModel = viewModel
        rootViewController.pushViewController(detailVC, animated: true)
        return .none
    }
}
