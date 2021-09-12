//
//  SearchResultViewModel.swift
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

final class SearchResultViewModel: Reactor {
    enum Action {
        case searchBarTextUpdated(String)
        case searchButtonTapped(String)
    }
    
    enum Mutation {
        case getKeywords([Keyword])
        case getTracks([Track])
        case error(Error)
    }
    
    struct State {
        var dataSource: [SearchResult.Model] = .init()
        var tracks: [Track] = .init()
        var error: Error?
    }

    let initialState: State = .init()
    
    private let getKeywordUseCase: GetKeywordUseCase
    private let searchTrackUseCase: SearchTrackUseCase!
            
    let disposeBag: DisposeBag = .init()
    
    init(
        getKeywordUseCase: GetKeywordUseCase,
        searchTrackUseCase: SearchTrackUseCase
    ) {
        self.getKeywordUseCase = getKeywordUseCase
        self.searchTrackUseCase = searchTrackUseCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .searchBarTextUpdated(let text):
            return getKeywordUseCase.getKeywordsContains(text: text)
                .compactMap { .getKeywords($0) }
                .catch { .just(.error($0)) }
        case .searchButtonTapped(let text):
            return searchTrackUseCase.getTracks(text)
                .compactMap { .getTracks($0) }
                .catch { .just(.error($0)) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .getKeywords(let keywords):
            let dataSource = SearchResult().buildModel(keywords)
            newState.dataSource = dataSource
        case .getTracks(let tracks):
            let dataSource = SearchResult().buildModel(tracks)
            newState.dataSource = dataSource
            newState.tracks = tracks
        case .error(let error):
            newState.error = error
        }
        
        return newState
    }
    
    func getTrack(_ trackId: Int) -> Track? {
        currentState.tracks.first(where: { $0.trackId == trackId })
    }
}
