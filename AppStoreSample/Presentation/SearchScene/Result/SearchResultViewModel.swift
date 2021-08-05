//
//  SearchResultViewModel.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/02.
//

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
    
    private let keywordUseCase: KeywordUseCase
    private let trackUseCase: TrackUseCase
    private let disposeBag: DisposeBag = .init()
    
    init(
        keywordUseCase: KeywordUseCase,
        trackUseCase: TrackUseCase
    ) {
        self.keywordUseCase = keywordUseCase
        self.trackUseCase = trackUseCase
    }
    
    func mutate(input: Input) -> Output {
        let getKeywords = getKeyword(input: input)
        let getTacks = getTracks(input: input)
        let saveKeyword = saveKeyword(input: input)
        
        // dataSource binding
        let dataSource = Observable
            .merge(
                getKeywords.data,
                getTacks.data
            )
            .asDriver(onErrorJustReturn: [])
            
        // errors binding
        let error = Observable
            .merge(
                getKeywords.error,
                getTacks.error,
                saveKeyword
            )
            .asSignal(onErrorJustReturn: RxError.unknown)
            
        return Output(dataSource: dataSource, error: error)
    }
    
    private func getKeyword(input: Input) -> (data: Observable<[SearchResult.Model]>, error: Observable<Error>) {
        let getKeywords = input.searchBarTextUpdated
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .withUnretained(self)
            .flatMapLatest {
                $0.0.keywordUseCase.getKeywordsContains(text: $0.1)
            }
            .materialize()
            .share()
        
        let getKeywordsData = Observable.merge(getKeywords)
            .compactMap { $0.element }
            .compactMap { SearchResult().buildModel($0) }
        
        let getKeywordsError = getKeywords
            .compactMap { $0.error }
        
        return (getKeywordsData, getKeywordsError)
    }
    
    private func getTracks(input: Input) -> (data: Observable<[SearchResult.Model]>, error: Observable<Error>) {
        let getTracks = input.searchButtonTapped
            .withUnretained(self)
            .flatMapLatest {
                $0.0.trackUseCase.getTracks($0.1)
            }
            .materialize()
            .share()
        
        let getTracksData = getTracks
            .compactMap { $0.element }
            .compactMap { SearchResult().buildModel($0) }
        
        let getTracksError = getTracks
            .compactMap { $0.error }
        
        return (getTracksData, getTracksError)
    }
    
    private func saveKeyword(input: Input) -> Observable<Error> {
        let saveKeyword = input.searchButtonTapped
            .withUnretained(self)
            .flatMapLatest {
                $0.0.keywordUseCase.saveKeyword($0.1)
            }
            .materialize()
            .share()
        
        let saveKeywordError = saveKeyword
            .compactMap { $0.error }
        
        return saveKeywordError
    }
 
    //    func mutate(input: Input) -> Output {
    //        // getKeywords
    //        let getKeywords = input.searchBarTextUpdated
    //            .distinctUntilChanged()
    //            .filter { !$0.isEmpty }
    //            .withUnretained(self)
    //            .flatMapLatest {
    //                $0.0.keywordUseCase.getKeywordsContains(text: $0.1)
    //            }
    //            .materialize()
    //            .share()
    //
    //        let getKeywordsData = Observable.merge(getKeywords)
    //            .compactMap { $0.element }
    //            .compactMap { SearchResult().buildModel($0) }
    //
    //        let getKeywordsError = getKeywords
    //            .compactMap { $0.error }
    //
    //        // saveKeyword
    //        let saveKeyword = input.searchButtonTapped
    //            .withUnretained(self)
    //            .flatMapLatest {
    //                $0.0.keywordUseCase.saveKeyword($0.1)
    //            }
    //            .materialize()
    //            .share()
    //
    //        let saveKeywordError = saveKeyword
    //            .compactMap { $0.error }
    //
    //        // getTracks
    //        let getTracks = input.searchButtonTapped
    //            .withUnretained(self)
    //            .flatMapLatest {
    //                $0.0.trackUseCase.getTracks($0.1)
    //            }
    //            .materialize()
    //            .share()
    //
    //        let getTracksData = getTracks
    //            .compactMap { $0.element }
    //            .compactMap { SearchResult().buildModel($0) }
    //
    //        let getTracksError = getTracks
    //            .compactMap { $0.error }
    //
    //        // dataSource binding
    //        let dataSource = Observable
    //            .merge(
    //                getTracksData,
    //                getKeywordsData
    //            )
    //            .asDriver(onErrorJustReturn: [])
    //
    //        // errors binding
    //        let error = Observable
    //            .merge(
    //                saveKeywordError,
    //                getTracksError,
    //                getKeywordsError
    //            )
    //            .asSignal(onErrorJustReturn: RxError.unknown)
    //
    //        return Output(dataSource: dataSource, error: error)
    //    }
}
