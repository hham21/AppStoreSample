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
import ReactorKit

final class SearchMainViewModel: Reactor, Stepper {
    enum Action {
        case initialLoad
        case reload
        case trackSelected(Track)
    }
    
    enum Mutation {
        case getKeyword([Keyword])
        case error(Error)
    }
    
    struct State {
        var dataSource: [SearchMain.Model] = []
        var error: Error?
    }
    
    let initialState: State = .init()
    let steps: PublishRelay<Step> = .init()
    
    private let getKeywordUseCase: GetKeywordUseCase
    
    let disposeBag: DisposeBag = .init()
    
    init(getKeywordUseCase: GetKeywordUseCase) {
        self.getKeywordUseCase = getKeywordUseCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .initialLoad, .reload:
            return getKeywordUseCase.getKeywords()
                .map { Mutation.getKeyword($0) }
        case .trackSelected(let track):
            steps.accept(AppStep.searchDetail(track: track))
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .getKeyword(let keywords):
            let dataSource = SearchMain().buildModel(keywords)
            newState.dataSource = dataSource
        case .error(let error):
            newState.error = error
        }
        
        return newState
    }
}
