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

final class SearchResultViewModel: ViewModelType {
    struct Input {
        let searchBarTextUpdated: PublishRelay<String> = .init()
        let searchButtonTapped: PublishRelay<String> = .init()
    }
    
    struct Output {
        let dataSource: Driver<[SearchResult.Model]>
        let error: Signal<Error>
    }
    
    lazy var input: Input = .init()
    lazy var output: Output = mutate(input: input)
    
    private let getKeywordUseCase: GetKeywordUseCase
    private let searchTrackUseCase: SearchTrackUseCase!
    
    private var tracks: BehaviorRelay<[Track]> = .init(value: [])
        
    private let disposeBag: DisposeBag = .init()
    
    init(
        getKeywordUseCase: GetKeywordUseCase,
        searchTrackUseCase: SearchTrackUseCase
    ) {
        self.getKeywordUseCase = getKeywordUseCase
        self.searchTrackUseCase = searchTrackUseCase
    }
    
    func mutate(input: Input) -> Output {
        // getKeywords
        let getKeywords = input.searchBarTextUpdated
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .withUnretained(self)
            .flatMapLatest {
                $0.0.getKeywordUseCase.getKeywordsContains(text: $0.1)
            }
            .materialize()
            .share()
        
        let getKeywordsData = Observable.merge(getKeywords)
            .compactMap { $0.element }
            .compactMap { SearchResult().buildModel($0) }
        
        let getKeywordsError = getKeywords
            .compactMap { $0.error }
        
        // getTracks
        let getTracks = input.searchButtonTapped
            .withUnretained(self)
            .flatMapLatest {
                $0.0.searchTrackUseCase.getTracks($0.1)
            }
            .materialize()
            .share()
        
        let getTracksData = getTracks
            .compactMap { $0.element }
            .do(onNext: { [weak self] tracks in
                self?.tracks.accept(tracks)
            })
            .compactMap { SearchResult().buildModel($0) }
        
        let getTracksError = getTracks
            .compactMap { $0.error }
        
        // dataSource binding
        let dataSource = Observable
            .merge(
                getTracksData,
                getKeywordsData
            )
            .asDriver(onErrorJustReturn: [])
        
        // errors binding
        let error = Observable
            .merge(
                getTracksError,
                getKeywordsError
            )
            .asSignal(onErrorJustReturn: RxError.unknown)
        
        return Output(dataSource: dataSource, error: error)
    }
    
    func getTrack(_ trackId: Int) -> Track? {
        tracks.value.first(where: { $0.trackId == trackId })
    }
}
