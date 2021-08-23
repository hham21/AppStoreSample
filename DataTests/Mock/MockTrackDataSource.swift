//
//  MockTrackDataSource.swift
//  DataTests
//
//  Created by Hyoungsu Ham on 2021/08/23.
//


@testable import AppStoreSample
@testable import Data
@testable import Domain
import RxSwift

class MocTrackDataSource: TrackDataSource {
    private func getMockTracks() -> Observable<[Track]> {
        do {
            let data = try Data.fromJSON(fileName: "SampleData")
            let response = try JSONDecoder().decode(Response.self, from: data)
            let trackDTOs = response.results
            let tracks = trackDTOs.compactMap { $0.asDomain() }
            return .just(tracks)
        } catch {
            return .error(RxError.noElements)
        }
    }
    
    func getTracks(_ query: String) -> Observable<[Track]> {
        return getMockTracks()
    }
}
