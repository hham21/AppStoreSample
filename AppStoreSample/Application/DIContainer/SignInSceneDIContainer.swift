//
//  SignInSceneDIContainer.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/19.
//

import Reusable

final class SignInSceneDIContainer {
    
    // MARK: - ViewModel
    
    func makeSignInViewModel() -> SignInViewModel {
        return SignInViewModel()
    }
    
    // MARK: - ViewControlelr
    
    func makeSignInRootViewController() -> UINavigationController {
        return UINavigationController()
    }
    
    func makeSignInViewController() -> SignInViewController {
        return SignInViewController.create(with: makeSignInViewModel())
    }
}
