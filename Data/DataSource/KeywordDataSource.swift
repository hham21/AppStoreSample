//
//  KeywordDataSource.swift
//  Data
//
//  Created by Hyoungsu Ham on 2021/08/03.
//

import Domain
import RxSwift

public protocol KeywordDataSource {
    func getKeywords() -> Observable<[Keyword]>
    func saveKeyword(_ keyword: Keyword) -> Observable<Void>
}
