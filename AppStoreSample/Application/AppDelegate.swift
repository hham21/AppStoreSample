//
//  AppDelegate.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/02.
//

import UIKit
import RxSwift
import RxFlow

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private let coordinator: FlowCoordinator = .init()
    private let disposeBag: DisposeBag = .init()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        startToLogCoordinator()
        startApp()
        return true
    }
    
    private func startApp() {
        let window = UIWindow(frame: UIScreen.main.bounds)
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

