//
//  UseCaseProviderImpl.swift
//  Data
//
//  Created by Hyoungsu Ham on 2021/08/05.
//

import Foundation
import Domain

public struct UseCaseProviderImpl: UseCaseProvider {
    public init() {}
    
    public func createTrackUseCase() -> TrackUseCase {
        let remoteDataSource: TrackDataSource = TrackAPIDataSource()
        let repo: TrackRepository = TrackRepositoryImpl(remoteSource: remoteDataSource)
        return TrackUseCaseImpl(repo: repo)
    }
    
    public func createKeywordUseCase() -> KeywordUseCase {
        let localSource: KeywordDataSource = KeywordRealmDataSource()
        let repo: KeywordRepository = KeywordRepositoryImpl(localSource: localSource)
        return KeywordUseCaseImpl(repo: repo)
    }
}
