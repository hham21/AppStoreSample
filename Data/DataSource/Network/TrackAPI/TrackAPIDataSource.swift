//
//  TrackAPIDataSource.swift
//  Data
//
//  Created by Hyoungsu Ham on 2021/08/05.
//

import Foundation
import RxSwift
import Domain
import Moya

public struct TrackAPIDataSource: TrackDataSource {
    public init() {}
    public func getTracks(_ query: String) -> Observable<[Track]> {
        .create { observer in
            
            let provider: MoyaProvider<TrackAPI> = .init()
            
            provider.request(.searchTracks(query: query)) { result in
                switch result {
                case .success(let response):
                    do {
                        let responseData = try JSONDecoder().decode(Response.self, from: response.data)
                        observer.onNext(responseData.results.compactMap { $0.asDomain() })
                    } catch {
                        observer.onError(error)
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}
