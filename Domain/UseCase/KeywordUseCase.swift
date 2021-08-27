//
//  KeywordUseCase.swift
//  Domain
//
//  Created by Hyoungsu Ham on 2021/08/02.
//

import Foundation
import RxSwift

public protocol KeywordUseCase {
    func getKeywords() -> Observable<[Keyword]>
    func getKeywordsContains(text: String) -> Observable<[Keyword]>
    func saveKeyword(_ keyword: String) -> Observable<Void>
}

public final class KeywordUseCaseImpl: KeywordUseCase {
    private let repo: KeywordRepository
    
    public init(repo: KeywordRepository) {
        self.repo = repo
    }
    
    public func getKeywords() -> Observable<[Keyword]> {
        repo.getKeywords()
    }
    
    public func getKeywordsContains(text: String) -> Observable<[Keyword]> {
        repo.getKeywordsContains(text: text)
    }
    
    public func saveKeyword(_ keyword: String) -> Observable<Void> {
        let keyword: Keyword = .init(text: keyword, date: Date())
        return repo.saveKeyword(keyword)
    }
}
