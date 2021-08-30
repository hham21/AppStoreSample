//
//  KeywordUseCase.swift
//  Domain
//
//  Created by Hyoungsu Ham on 2021/08/02.
//

import Foundation
import RxSwift

public protocol GetKeywordUseCase {
    func getKeywords() -> Observable<[Keyword]>
    func getKeywordsContains(text: String) -> Observable<[Keyword]>
}

public final class GetKeywordUseCaseImple: GetKeywordUseCase {
    private let keywordRepo: KeywordRepository
    
    public init(keywordRepo: KeywordRepository) {
        self.keywordRepo = keywordRepo
    }
    
    public func getKeywords() -> Observable<[Keyword]> {
        keywordRepo.getKeywords()
    }
    
    public func getKeywordsContains(text: String) -> Observable<[Keyword]> {
        keywordRepo.getKeywordsContains(text: text)
    }
}
