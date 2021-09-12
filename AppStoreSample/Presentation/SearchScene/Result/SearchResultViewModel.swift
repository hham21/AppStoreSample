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

final class SearchResultViewModel: ViewModel {
    enum Input {
        case searchBarTextUpdated(String)
        case searchButtonTapped(String)
    }
    
    enum Mutation {
        case getKeywords([Keyword])
        case getTracks([Track])
        case error(Error)
    }
    
    struct Output {
        var dataSource: [SearchResult.Model]?
        var tracks: [Track]?
        var error: Error?
    }

    let input: PublishRelay<Input> = .init()
    internal let mutation: PublishRelay<Mutation> = .init()
    let output: BehaviorRelay<Output> = .init(value: .init())
    
    private let getKeywordUseCase: GetKeywordUseCase
    private let searchTrackUseCase: SearchTrackUseCase!
            
    internal let disposeBag: DisposeBag = .init()
    
    init(
        getKeywordUseCase: GetKeywordUseCase,
        searchTrackUseCase: SearchTrackUseCase
    ) {
        self.getKeywordUseCase = getKeywordUseCase
        self.searchTrackUseCase = searchTrackUseCase
        bind()
    }
    
    internal func mutate(input: Input) -> Observable<Mutation> {
        switch input {
        case .searchBarTextUpdated(let text):
            return Observable.just(text)
                .withUnretained(self)
                .flatMapLatest {
                    $0.0.getKeywordUseCase.getKeywordsContains(text: $0.1)
                }
                .compactMap { .getKeywords($0) }
                .catch { .just(.error($0)) }
        case .searchButtonTapped(let text):
            return Observable.just(text)
                .withUnretained(self)
                .flatMapLatest {
                    $0.0.searchTrackUseCase.getTracks($0.1)
                }
                .compactMap { .getTracks($0) }
                .catch { .just(.error($0)) }
        }
    }
    
    internal func reduce(mutation: Mutation) -> Observable<Output> {
        var newOuput = output.value
        
        switch mutation {
        case .getKeywords(let keywords):
            let dataSource = SearchResult().buildModel(keywords)
            newOuput.dataSource = dataSource
        case .getTracks(let tracks):
            let dataSource = SearchResult().buildModel(tracks)
            newOuput.dataSource = dataSource
            newOuput.tracks = tracks
        case .error(let error):
            newOuput.error = error
        }
        
        return .just(newOuput)
    }
    
    func getTrack(_ trackId: Int) -> Track? {
        output.value.tracks?.first(where: { $0.trackId == trackId })
    }
}
