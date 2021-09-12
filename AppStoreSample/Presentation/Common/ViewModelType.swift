//
//  ViewModelType.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/02.
//

import Foundation
import RxSwift
import RxCocoa
import RxFlow

protocol ViewModel: AnyObject {
    associatedtype Input
    associatedtype Mutation
    associatedtype Output
    
    var input: PublishRelay<Input> { get }
    var mutation: PublishRelay<Mutation> { get }
    var output: BehaviorRelay<Output> { get }
    var disposeBag: DisposeBag { get }
    
    func bind()
    func mutate(input: Input) -> Observable<Mutation>
    func reduce(mutation: Mutation) -> Observable<Output>
}

extension ViewModel {
    var mutation: PublishRelay<Mutation> { .init() }
    var disposeBag: DisposeBag { .init() }
    
    func bind() {
        input
            .withUnretained(self)
            .flatMapLatest { $0.0.mutate(input: $0.1) }
            .bind(to: mutation)
            .disposed(by: disposeBag)
        
        mutation
            .withUnretained(self)
            .flatMapLatest { $0.0.reduce(mutation: $0.1) }
            .bind(to: output)
            .disposed(by: disposeBag)
    }
}

extension ViewModel where Input == Mutation {
    func mutate(input: Input) -> Observable<Mutation> {
        .just(input)
    }
}

protocol ViewModelWithStepper: ViewModel, Stepper {
    var steps: PublishRelay<Step> { get }
    func coordinate(input: Input) -> Observable<Step>
}

extension ViewModelWithStepper {
    func bind() {
        input
            .withUnretained(self)
            .flatMapLatest { $0.0.mutate(input: $0.1) }
            .bind(to: mutation)
            .disposed(by: disposeBag)
        
        input
            .withUnretained(self)
            .flatMapLatest { $0.0.coordinate(input: $0.1) }
            .observe(on: MainScheduler.instance)
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        mutation
            .withUnretained(self)
            .flatMapLatest { $0.0.reduce(mutation: $0.1) }
            .observe(on: MainScheduler.instance)
            .bind(to: output)
            .disposed(by: disposeBag)
    }
}
