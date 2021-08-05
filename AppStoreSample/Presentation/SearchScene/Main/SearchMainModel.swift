//
//  SearchMainModel.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/05.
//

import Domain
import RxSwift
import RxCocoa
import RxDataSources

// MARK: - SearchMain

struct SearchMain {
    typealias Model = SectionModel<Section, Item>
    typealias DataSource = RxTableViewSectionedReloadDataSource<Model>
    
    enum Section {
        case none
    }
    
    enum Item {
        case header
        case recentKeyword(String)
    }
    
    enum Const {
        static let title: String = "검색"
        static let searchBarCancelButtonKey: String = "cancelButtonText"
        static let searchBarCancelButtonTitle: String = "취소"
        static let searchBarPlaceHodlerText: String = "게임, 앱, 스토리 등"
        static let mainHeaderCellHeight: CGFloat = 66.0
        static let recentKeywordCellHeight: CGFloat = 44.0
    }
    
    func buildModel(_ data: [Keyword]) -> [Model] {
        var items: [Item] = .init()
        items.append(buildHeaderItem())
        items.append(contentsOf: buildRecentKeywordCellItem(with: data))
        return [.init(model: .none, items: items)]
    }
    
    private func buildHeaderItem() -> Item {
        return .header
    }
    
    private func buildRecentKeywordCellItem(with data: [Keyword]) -> [Item] {
        return data.map { Item.recentKeyword($0.text) }
    }
}
