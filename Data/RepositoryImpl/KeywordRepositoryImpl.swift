//
//  KeywordRepositoryImpl.swift
//  Data
//
//  Created by Hyoungsu Ham on 2021/08/03.
//

import Domain
import RxSwift

public struct KeywordRepositoryImpl: KeywordRepository {
    private let localDataSource: KeywordDataSource
    
    public init(localDataSource: KeywordDataSource) {
        self.localDataSource = localDataSource
    }
    
    public func getKeywords() -> Observable<[Keyword]> {
        localDataSource.getKeywords()
    }
    
    public func getKeywordsContains(text: String) -> Observable<[Keyword]> {
        localDataSource.getKeywordsContains(text: text)
    }
    
    public func saveKeyword(_ keyword: Keyword) -> Observable<Void> {
        localDataSource.saveKeyword(keyword)
    }
}
