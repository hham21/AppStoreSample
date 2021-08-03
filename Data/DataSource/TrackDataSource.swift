//
//  TrackDataSource.swift
//  Data
//
//  Created by Hyoungsu Ham on 2021/08/03.
//

import Domain
import RxSwift

public protocol TrackDataSource {
    func getTracks(_ query: String) -> Observable<[Track]>
}
