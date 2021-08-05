//
//  UseCaseProvider.swift
//  Domain
//
//  Created by Hyoungsu Ham on 2021/08/05.
//

import Foundation

public protocol UseCaseProvider {
    func createTrackUseCase() -> TrackUseCase
    func createKeywordUseCase() -> KeywordUseCase
}
