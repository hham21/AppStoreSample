//
//  KeywordRepositoryImpl.swift
//  Data
//
//  Created by Hyoungsu Ham on 2021/08/03.
//

import Domain
import RxSwift

struct KeywordRepositoryImpl: KeywordRepository {
    private let localSource: KeywordDataSource
    
    init(localSource: KeywordDataSource) {
        self.localSource = localSource
    }
    
    func getKeywords() -> Observable<[Keyword]> {
        localSource.getKeywords()
    }
    
    func getKeywordsContains(text: String) -> Observable<[Keyword]> {
        localSource.getKeywordsContains(text: text)
    }
    
    func saveKeyword(_ keyword: Keyword) -> Observable<Void> {
        localSource.saveKeyword(keyword)
    }
}
