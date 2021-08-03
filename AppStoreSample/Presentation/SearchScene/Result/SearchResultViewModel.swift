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

    struct SearchViewItemModel {
        func parseData(_ tracks: [Track]) -> [Item] {
            return tracks.map {  buildTrackCellItem(with: $0) }
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
        
        func parseData(text: String, keywords: [Keyword]) -> [Item] {
            return keywords
                .filter { $0.text.localizedCaseInsensitiveContains(text) }
                .map { Item.recentKeyword($0.text) }
        }
    }

}

final class SearchResultViewModel: ViewModelType {
    struct Input {
        let searchBarTextUpdated: PublishRelay<String> = .init()
        let searchButtonTapped: PublishRelay<String> = .init()
    }
    
    struct Output {
        let dataSource: Driver<[SearchResult.Model]>
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
        let saveKeyword = saveKeyword(input: input)
        return Output(dataSource: .just([]))
    }
    
    private func saveKeyword(input: Input) -> Observable<Void> {
        input.searchButtonTapped
            .withUnretained(self)
            .flatMapLatest {
                $0.0.keywordUseCase.saveKeyword($0.1)
            }
    }
}
