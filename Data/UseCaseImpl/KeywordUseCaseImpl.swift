//
//  KeywordUseCaseImpl.swift
//  Data
//
//  Created by Hyoungsu Ham on 2021/08/03.
//

import Domain
import RxSwift

public struct KeywordUseCaseProviderImpl: KeywordUseCaseProvider {
    
    public init() {}
    
    public func createKeywordUseCase() -> KeywordUseCase {
        let localSource: KeywordDataSource = KeywordRealmDataSource()
        let repo: KeywordRepository = KeywordRepositoryImpl(localSource: localSource)
        return KeywordUseCaseImpl(repo: repo)
    }
}

final class KeywordUseCaseImpl: KeywordUseCase {
    private let repo: KeywordRepository
    
    init(repo: KeywordRepository) {
        self.repo = repo
    }
    
    func getKeywords() -> Observable<[Keyword]> {
        repo.getKeywords()
    }
    
    func saveKeyword(_ keyword: String) -> Observable<Void> {
        let keyword: Keyword = .init(text: keyword, date: Date())
        return repo.saveKeyword(keyword)
    }
}
