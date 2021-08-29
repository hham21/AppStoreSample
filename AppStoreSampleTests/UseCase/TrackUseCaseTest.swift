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
    var mockKeywordDataSource: KeywordDataSource!
    var trackRespository: TrackRepository!
    var keywordRepository: KeywordRepository!
    var sut: SearchTrackUseCase!
    var disposeBag: DisposeBag = .init()
    
    override func setUp() {
        super.setUp()
        mockDataSource = MockTrackDataSource()
        trackRespository = TrackRepositoryImpl(remoteDataSource: mockDataSource)
        mockKeywordDataSource = MockKeywordDataSource()
        keywordRepository = KeywordRepositoryImpl(localDataSource: mockKeywordDataSource)
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
        sut = SearchTrackUseCaseImpl(trackRepo: trackRespository, keywordRepo: keywordRepository)
        
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
