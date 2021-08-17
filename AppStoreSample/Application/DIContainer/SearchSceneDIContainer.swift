//
//  SearchSceneDIContainer.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/16.
//

import UIKit
import Domain
import Data

final class SearchSceneDIContainer {
    
    // MARK: - DataSource
    
    func makeKeywordDataSource() -> KeywordDataSource {
        return KeywordRealmDataSource()
    }
    
    func makeTrackDataSource() -> TrackDataSource {
        return TrackAPIDataSource()
    }
    
    // MARK: - Repository
    
    func makeKeywordRepository() -> KeywordRepository {
        return KeywordRepositoryImpl(localSource: makeKeywordDataSource())
    }
    
    func makeTrackRepository() -> TrackRepository {
        return TrackRepositoryImpl(remoteSource: makeTrackDataSource())
    }
    
    // MARK: - UseCase
    
    func makeKeywordUseCase() -> KeywordUseCase {
        return KeywordUseCaseImpl(repo: makeKeywordRepository())
    }
    
    func makeTrackUseCase() -> TrackUseCase {
        return TrackUseCaseImpl(repo: makeTrackRepository())
    }
    
    // MARK: - ViewModel
    
    func makeSearchResultViewModel() -> SearchResultViewModel {
        return .init(
            keywordUseCase: makeKeywordUseCase(),
            trackUseCase: makeTrackUseCase()
        )
    }
    
    func makeSearchMainViewModel() -> SearchMainViewModel {
        return .init(
            keywordUseCase: makeKeywordUseCase()
        )
    }
    
    // MARK: - ViewControlelr
    
    func makeSearchSceneRootController() -> UINavigationController {
        return UINavigationController()
    }
    
    func makeSearchResultViewController() -> SearchResultViewController {
        return .create(viewModel: makeSearchResultViewModel())
    }
    
    func makeSearchMainViewController() -> SearchMainViewController {
        return .create(
            with: makeSearchMainViewModel(),
            searchResultVC: makeSearchResultViewController()
        )
    }
}
 
