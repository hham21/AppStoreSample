//
//  TrackUseCase.swift
//  Domain
//
//  Created by Hyoungsu Ham on 2021/08/02.
//

import Foundation
import RxSwift

public protocol TrackUseCase {
    func getTracks(_ query: String) -> Observable<[Track]>
}

public final class TrackUseCaseImpl: TrackUseCase {
    private let repo: TrackRepository
    
    public init(repo: TrackRepository) {
        self.repo = repo
    }
    
    public func getTracks(_ query: String) -> Observable<[Track]> {
        repo.getTracks(query)
    }
}
