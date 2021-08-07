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
    private let provider = Application.shared.useCaseProvider
    
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
        case .searchDetail(let track):
            return coordinateToSearchDetailVC(with: track)
        default:
            return .none
        }
    }
    
    private func coordinateToSearchMainVC() -> FlowContributors {
        let keywordUseCase: KeywordUseCase = provider.createKeywordUseCase()
        let trackUseCase: TrackUseCase = provider.createTrackUseCase()
        let resultViewModel: SearchResultViewModel = .init(keywordUseCase: keywordUseCase, trackUseCase: trackUseCase)
        let resultVC: SearchResultViewController = .create(viewModel: resultViewModel)
        let mainViewModel: SearchMainViewModel = .init(keywordUseCase: keywordUseCase)
        let mainVC: SearchMainViewController = .create(with: mainViewModel, searchResultVC: resultVC)
        
        rootViewController.setViewControllers([mainVC], animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: mainVC,
                                                 withNextStepper: mainViewModel))
    }
    
    private func coordinateToSearchDetailVC(with track: Track) -> FlowContributors {
        let detailVC: SearchDetailViewController = .create(with: track)
        rootViewController.pushViewController(detailVC, animated: true)
        return .none
        
        
//        let reactor = HomeDetailReactor(provider: provider)
//        let vc = HomeDetailVC(with: reactor, title: ID)
//        self.rootViewController.pushViewController(vc, animated: true)
//        return .one(flowContributor: .contribute(withNextPresentable: vc,
//                                                 withNextStepper: reactor))
        
    }
}



