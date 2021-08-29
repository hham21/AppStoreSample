//
//  KeywordRealmDataSource.swift
//  Data
//
//  Created by Hyoungsu Ham on 2021/08/03.
//

import Domain
import RxSwift
import RealmSwift

public struct KeywordRealmDataSource: KeywordDataSource {
    private let DB: RealmDB = .init()

    public init() {}

    public func getKeywords() -> Observable<[Keyword]> {
        return readKeywords()
            .compactMap { $0.compactMap { $0.asDomain() } }
    }
    
    public func getKeywordsContains(text: String) -> Observable<[Keyword]> {
        let predicate: NSPredicate = .init(
            format: "\(#keyPath(RMKeyword.text)) CONTAINS[cd] %@",
            argumentArray: [text as NSString]
        )
        return readKeywords(predicate: predicate)
            .compactMap { $0.compactMap { $0.asDomain() } }
    }
    
    public func saveKeyword(_ keyword: Keyword) -> Observable<Void> {
        return updateKeyword(keyword)
    }
    
    private func readKeywords(predicate: NSPredicate? = nil) -> Observable<[RMKeyword]> {
        return DB.read(predicate: predicate)
    }
    
    private func updateKeyword(_ keyword: Keyword) -> Observable<Void> {
        return DB.update(object: keyword.asRealm())
    }
}
