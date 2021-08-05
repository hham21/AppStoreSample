//
//  KeywordUseCaseImpl.swift
//  Data
//
//  Created by Hyoungsu Ham on 2021/08/03.
//

import Domain
import RxSwift

final class KeywordUseCaseImpl: KeywordUseCase {
    private let repo: KeywordRepository
    
    init(repo: KeywordRepository) {
        self.repo = repo
    }
    
    func getKeywords() -> Observable<[Keyword]> {
        repo.getKeywords()
    }
    
    func getKeywordsContains(text: String) -> Observable<[Keyword]> {
        repo.getKeywordsContains(text: text)
    }
    
    func saveKeyword(_ keyword: String) -> Observable<Void> {
        let keyword: Keyword = .init(text: keyword, date: Date())
        return repo.saveKeyword(keyword)
    }
}
