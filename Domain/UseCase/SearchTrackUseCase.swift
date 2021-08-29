//
//  SearchTrackUseCase.swift
//  Domain
//
//  Created by Hyoungsu Ham on 2021/08/29.
//

import Foundation
import RxSwift

public protocol SearchTrackUseCase {
    func getTracks(_ query: String) -> Observable<[Track]>
}

public final class SearchTrackUseCaseImpl: SearchTrackUseCase {
    private let trackRepo: TrackRepository
    private let keywordRepo: KeywordRepository
    
    private let disposeBag: DisposeBag = .init()
    
    public init(trackRepo: TrackRepository, keywordRepo: KeywordRepository) {
        self.trackRepo = trackRepo
        self.keywordRepo = keywordRepo
    }
    
    public func getTracks(_ query: String) -> Observable<[Track]> {
        trackRepo.getTracks(query)
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.saveKeyword(query)
            })
    }
    
    private func saveKeyword(_ query: String) {
        let keyword: Keyword = createKeyword(text: query)
        
        keywordRepo.saveKeyword(keyword)
            .subscribe(onNext: { _ in
                dump("saveKeyword success: \(query)")
            }, onError: { error in
                dump(error)
            })
            .disposed(by: disposeBag)
    }
    
    private func createKeyword(text: String) -> Keyword {
        return .init(text: text, date: Date())
    }
}
