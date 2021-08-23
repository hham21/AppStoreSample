//
//  DIContainer.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/22.
//

import UIKit
import Domain
import Data
import Swinject
import SwinjectStoryboard

let DIContainer: Container = .init { container in
    // MARK: - App
    
    // Stepper
    
    container.register(SearchStepper.self) { _ in
        SearchStepper()
    }
    
    // Flow
    
    container.register(SignInFlow.self) { _ in
        SignInFlow()
    }
    
    container.register(MainFlow.self) { r in
        MainFlow(
            searchFlow: r.resolve(SearchFlow.self)!,
            settingFlow: r.resolve(SettingFlow.self)!
        )
    }
    
    container.register(SearchFlow.self) { r in
        SearchFlow(stepper: r.resolve(SearchStepper.self)!)
    }
    
    container.register(SettingFlow.self) { _ in
        SettingFlow(stepper: .init())
    }
    
    // Service
    
    container.register(AuthService.self) { _ in
        AuthServiceImpl()
    }
    
    // MARK: - SignIn
    
    // ViewModel
    
    container.register(SignInViewModel.self) { _ in
        SignInViewModel()
    }
    
    // ViewController
    
    container.register(SignInViewController.self) { r in
        SignInViewController.create(with: r.resolve(SignInViewModel.self)!)
    }
    
    // MARK: - Search
    
    // DataSource
    
    container.register(KeywordDataSource.self) { _ in
        KeywordRealmDataSource()
    }
    
    container.register(TrackDataSource.self) { _ in
        TrackAPIDataSource()
    }
    
    // Repository
    
    container.register(KeywordRepository.self) { r in
        KeywordRepositoryImpl(localDataSource: r.resolve(KeywordDataSource.self)!)
    }
    
    container.register(TrackRepository.self) { r in
        TrackRepositoryImpl(remoteDataSource: r.resolve(TrackDataSource.self)!)
    }
    
    // UseCase
    
    container.register(KeywordUseCase.self) { r in
        KeywordUseCaseImpl(repo: r.resolve(KeywordRepository.self)!)
    }
    
    container.register(TrackUseCase.self) { r in
        TrackUseCaseImpl(repo: r.resolve(TrackRepository.self)!)
    }
    
    // ViewModel
    
    container.register(SearchResultViewModel.self) { r in
        SearchResultViewModel(
            keywordUseCase: r.resolve(KeywordUseCase.self)!,
            trackUseCase: r.resolve(TrackUseCase.self)!)
    }
    
    container.register(SearchMainViewModel.self) { r in
        SearchMainViewModel(
            keywordUseCase: r.resolve(KeywordUseCase.self)!
        )
    }
    
    container.register(DetailViewModel.self) { _, track in
        DetailViewModel(with: track)
    }
    
    // ViewController
    
    container.register(SearchResultViewController.self) { r in
        .create(viewModel: r.resolve(SearchResultViewModel.self)!)
    }

    container.register(SearchMainViewController.self) { r in
        .create(
            with: r.resolve(SearchMainViewModel.self)!,
            searchResultVC: r.resolve(SearchResultViewController.self)!
        )
    }

    container.register(SearchDetailViewController.self) { _ in
        .instantiate()
    }
}
