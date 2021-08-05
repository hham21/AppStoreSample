//
//  KeywordRepository.swift
//  Domain
//
//  Created by Hyoungsu Ham on 2021/08/03.
//

import RxSwift

public protocol KeywordRepository {
    func getKeywords() -> Observable<[Keyword]>
    func getKeywordsContains(text: String) -> Observable<[Keyword]>
    func saveKeyword(_ keyword: Keyword) -> Observable<Void>
}
