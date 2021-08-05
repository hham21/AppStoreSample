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

struct SearchResult {
    typealias Model = SectionModel<Section, Item>
    typealias DataSource = RxTableViewSectionedReloadDataSource<Model>

    enum Item {
        case recentKeyword(String)
        case track(SearchTrackCell.Model)
    }

    enum Section {
        case none
    }
    
    enum Const {
        static let recentKeywordCellHeight: CGFloat = 44.0
        static let trackCellHeight: CGFloat = 280.0
    }
    
    func buildModel(_ data: [Track]) -> [Model] {
        var items: [Item] = .init()
        items.append(contentsOf: data.map { buildTrackCellItem(with: $0) })
        return [.init(model: .none, items: items)]
    }
    
    private func buildTrackCellItem(with data: Track) -> Item {
        let cellData: SearchTrackCell.Model = .init(
            trackId: data.trackId,
            trackName: data.trackName,
            sellerName: data.sellerName,
            screenshotURLs: data.screenshotURLs,
            artworkURL: data.artworkURL,
            rating: data.rating ?? 0,
            ratingCount: data.ratingCount ?? 0
        )
        return .track(cellData)
    }
    
    func buildModel(_ data: [Keyword]) -> [Model] {
        var items: [Item] = .init()
        items.append(contentsOf: data.map { buildKeywordCellModel(with: $0) })
        return [.init(model: .none, items: items)]
    }
    
    private func buildKeywordCellModel(with data: Keyword) -> Item {
        return Item.recentKeyword(data.text)
    }
}

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
        // getKeywords
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
        
        // saveKeyword
        let saveKeyword = input.searchButtonTapped
            .withUnretained(self)
            .flatMapLatest {
                $0.0.keywordUseCase.saveKeyword($0.1)
            }
            .materialize()
            .share()
        
        let saveKeywordError = saveKeyword
            .compactMap { $0.error }
        
        // getTracks
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
                saveKeywordError,
                getTracksError,
                getKeywordsError
            )
            .asSignal(onErrorJustReturn: RxError.unknown)
            
        return Output(dataSource: dataSource, error: error)
    }
}
