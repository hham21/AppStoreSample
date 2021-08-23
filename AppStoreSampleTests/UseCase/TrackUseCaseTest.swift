//
//  TrackUseCaseTest.swift
//  AppStoreSampleTests
//
//  Created by Hyoungsu Ham on 2021/08/24.
//

@testable import Domain
@testable import Data
import XCTest
import RxSwift

class TrackUseCaseTest: XCTestCase {
    var mockDataSource: TrackDataSource!
    var trackRespository: TrackRepository!
    var sut: TrackUseCase!
    var disposeBag: DisposeBag = .init()
    
    override func setUp() {
        super.setUp()
        mockDataSource = MockTrackDataSource()
        trackRespository = TrackRepositoryImpl(remoteDataSource: mockDataSource)
    }
    
    override func tearDown() {
        mockDataSource = nil
        trackRespository = nil
        sut = nil
        disposeBag = .init()
        super.tearDown()
    }
    
    func test_getTracks_givenUseCase() {
        // given
        sut = TrackUseCaseImpl(repo: trackRespository)
        
        // when
        sut.getTracks("스무디")
            .subscribe(onNext: { tracks in
                print("tracks.count", tracks.count)
                // then
                XCTAssertGreaterThan(tracks.count, 0, "tracks is empty.")
            }, onError: { error in
                // then
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}
