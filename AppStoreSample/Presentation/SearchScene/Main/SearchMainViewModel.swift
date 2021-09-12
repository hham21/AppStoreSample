//
//  SearchMainViewModel.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/02.
//

import Domain
import RxSwift
import RxCocoa
import RxDataSources
import RxFlow

final class SearchMainViewModel: ViewModelWithStepper {
    enum Input {
        case initialLoad
        case reload
        case trackSelected(Track)
    }
    
    enum Mutation {
        case getKeyword([Keyword])
        case error(Error)
    }
    
    struct Output {
        var dataSource: [SearchMain.Model]?
        var error: Error?
    }
    
    let input: PublishRelay<Input> = .init()
    internal var mutation: PublishRelay<Mutation> = .init()
    let output: BehaviorRelay<Output> = .init(value: .init())
    
    var steps: PublishRelay<Step> = .init()
    
    private let getKeywordUseCase: GetKeywordUseCase
    internal let disposeBag: DisposeBag = .init()
    
    init(getKeywordUseCase: GetKeywordUseCase) {
        self.getKeywordUseCase = getKeywordUseCase
        bind()
    }
    
    internal func mutate(input: Input) -> Observable<Mutation> {
        switch input {
        case .initialLoad, .reload:
            // getKeywords
            return Observable.just(())
                .withUnretained(self)
                .flatMapLatest {
                    $0.0.getKeywordUseCase.getKeywords()
                }
                .map { Mutation.getKeyword($0) }
        default:
            return Observable.empty()
        }
    }
    
    internal func reduce(mutation: Mutation) -> Observable<Output> {
        var newOutput = output.value
        
        switch mutation {
        case .getKeyword(let keywords):
            let dataSource = SearchMain().buildModel(keywords)
            newOutput.dataSource = dataSource
        case .error(let error):
            newOutput.error = error
        }
        
        return .just(newOutput)
    }
    
    internal func coordinate(input: Input) -> Observable<Step> {
        switch input {
        case .trackSelected(let track):
            return Observable.just(track)
                .compactMap { AppStep.searchDetail(track: $0) }
        default:
            return Observable.empty()
        }
    }
}
