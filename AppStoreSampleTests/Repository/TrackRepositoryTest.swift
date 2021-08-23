//
//  TrackRepositoryTest.swift
//  AppStoreSampleTests
//
//  Created by Hyoungsu Ham on 2021/08/24.
//

@testable import Domain
@testable import Data
import Foundation
import XCTest
import RxSwift

class TrackRepositoryTest: XCTestCase {
    var mockDataSource: TrackDataSource!
    var sut: TrackRepository!
    var disposeBag: DisposeBag = .init()
    
    override func setUp() {
        super.setUp()
        mockDataSource = MockTrackDataSource()
    }
    
    override func tearDown() {
        mockDataSource = nil
        sut = nil
        disposeBag = .init()
        super.tearDown()
    }
    
    func test_getTracks_givenRepository() {
        // given
        sut = TrackRepositoryImpl(remoteDataSource: mockDataSource)
        
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

