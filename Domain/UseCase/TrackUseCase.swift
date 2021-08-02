//
//  TrackUseCase.swift
//  Domain
//
//  Created by Hyoungsu Ham on 2021/08/02.
//

import Foundation
import RxSwift

protocol TrackUseCase {
    func getTracks(_ query: String) -> Observable<[Track]>
}
