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
    func saveKeyword(_ keyword: Keyword) -> Observable<Void>
}
