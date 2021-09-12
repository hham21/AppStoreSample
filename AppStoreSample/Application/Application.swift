//
//  Application.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/05.
//

import Foundation
import Domain
import Data
import RxSwift
import RxFlow
import Swinject

final class Application {
    static let shared: Application = .init()
        
    private let coordinator: FlowCoordinator = .init()
    private let disposeBag: DisposeBag = .init()
    
    private init() {}
    
    func startApp(with window: UIWindow) {
        let appFlow: AppFlow = .init(with: window)
        let stepper: AppStepper = .init()
        Container.loggingFunction = nil
        startToLogCoordinator()
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
