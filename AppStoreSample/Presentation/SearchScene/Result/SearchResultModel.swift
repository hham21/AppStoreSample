//
//  SearchResultModel.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/05.
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
