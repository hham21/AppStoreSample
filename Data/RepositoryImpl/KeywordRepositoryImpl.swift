//
//  KeywordRepositoryImpl.swift
//  Data
//
//  Created by Hyoungsu Ham on 2021/08/03.
//

import Domain
import RxSwift

public struct KeywordRepositoryImpl: KeywordRepository {
    private let localSource: KeywordDataSource
    
    public init(localSource: KeywordDataSource) {
        self.localSource = localSource
    }
    
    public func getKeywords() -> Observable<[Keyword]> {
        localSource.getKeywords()
    }
    
    public func getKeywordsContains(text: String) -> Observable<[Keyword]> {
        localSource.getKeywordsContains(text: text)
    }
    
    public func saveKeyword(_ keyword: Keyword) -> Observable<Void> {
        localSource.saveKeyword(keyword)
    }
}
