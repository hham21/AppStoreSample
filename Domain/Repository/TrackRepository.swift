//
//  TrackRepository.swift
//  Domain
//
//  Created by Hyoungsu Ham on 2021/08/03.
//

import RxSwift

public protocol TrackRepository {
    func getTracks(_ query: String) -> Observable<[Track]>
}
