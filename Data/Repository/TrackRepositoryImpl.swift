//
//  TrackRepositoryImpl.swift
//  Data
//
//  Created by Hyoungsu Ham on 2021/08/03.
//

import Domain
import RxSwift

public class TrackRepositoryImpl: TrackRepository {
    private let remoteDataSource: TrackDataSource
    
    public init(remoteDataSource: TrackDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    public func getTracks(_ query: String) -> Observable<[Track]> {
        remoteDataSource.getTracks(query)
    }
}
