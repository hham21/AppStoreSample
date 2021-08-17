//
//  TrackUseCaseImpl.swift
//  Data
//
//  Created by Hyoungsu Ham on 2021/08/04.
//

import Domain
import RxSwift

public final class TrackUseCaseImpl: TrackUseCase {
    private let repo: TrackRepository
    
    public init(repo: TrackRepository) {
        self.repo = repo
    }
    
    public func getTracks(_ query: String) -> Observable<[Track]> {
        repo.getTracks(query)
    }
}

