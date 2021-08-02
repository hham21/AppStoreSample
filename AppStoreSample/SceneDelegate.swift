//
//  SceneDelegate.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/02.
//

import UIKit
import RxSwift
import RxFlow

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private let coordinator: FlowCoordinator = .init()
    private let disposeBag: DisposeBag = .init()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        startToLogCoordinator()
        startApp(with: windowScene)
    }
    
    private func startApp(with windowScene: UIWindowScene) {
        let window: UIWindow = .init(windowScene: windowScene)
        self.window = window
        
        let appFlow: AppFlow = .init(with: window)
        let stepper: AppStepper = .init()
        
        coordinator.coordinate(flow: appFlow, with: stepper)
        
        window.makeKeyAndVisible()
    }
    
    // log
    private func startToLogCoordinator() {
        coordinator.rx.willNavigate
            .subscribe(onNext: { flow, step in
                dump("will navigate to flow: \(flow), step: \(step)")
            })
            .disposed(by: disposeBag)
    }
}
