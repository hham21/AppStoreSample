//
//  SettingViewModel.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/20.
//

import RxSwift
import RxCocoa
import RxFlow

final class SettingViewModel: Stepper {
    struct Input {
        let signOutTapped: PublishRelay<Void> = .init()
    }
    
    let input: Input = .init()
    var steps: PublishRelay<Step> = .init()
    
    private let disposeBag: DisposeBag = .init()
    
    init() {
        bind()
    }
    
    private func bind() {
        input.signOutTapped
            .map { _ in AppStep.signedOut }
            .bind(to: steps)
            .disposed(by: disposeBag)
    }
}
