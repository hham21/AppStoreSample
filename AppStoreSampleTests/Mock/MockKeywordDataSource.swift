//
//  MockKeywordDataSource.swift
//  AppStoreSampleTests
//
//  Created by Hyoungsu Ham on 2021/08/24.
//

@testable import AppStoreSample
@testable import Data
@testable import Domain
import RxSwift

class MockKeywordDataSource: KeywordDataSource {
    func getKeywords() -> Observable<[Keyword]> {
        return getSampleKeywords()
    }
    
    func getKeywordsContains(text: String) -> Observable<[Keyword]> {
        return getSampleKeywords()
    }
    
    func saveKeyword(_ keyword: Keyword) -> Observable<Void> {
        return .just(())
    }
    
    private func getSampleKeywords() -> Observable<[Keyword]> {
        return .just([.init(text: "스무디", date: Date())])
    }
}
