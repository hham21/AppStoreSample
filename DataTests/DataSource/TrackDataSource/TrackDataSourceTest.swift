//
//  TrackDataSourceTest.swift
//  DataTests
//
//  Created by Hyoungsu Ham on 2021/08/23.
//

@testable import AppStoreSample
@testable import Data
@testable import Domain
import XCTest
import Moya
import RxSwift

class TrackDataSourceTest: XCTestCase {
    var sut: TrackDataSource!
    var disposeBag: DisposeBag = .init()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        disposeBag = .init()
        super.tearDown()
    }
    
    func test_getTracks_givenRealDataSource() {
        let expectation: XCTestExpectation = .init()
        
        // given
        sut = TrackAPIDataSource()
        
        // when
        sut.getTracks("스무디")
            .subscribe(onNext: { tracks in
                print("tracks.count", tracks.count)
                // then
                expectation.fulfill()
            }, onError: { error in
                // then
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_getTracks_givenMocDataSource() {
        let expectation: XCTestExpectation = .init()
        
        // given
        sut = MocTrackDataSource()
        
        // when
        sut.getTracks("스무디")
            .subscribe(onNext: { tracks in
                print("tracks.count", tracks.count)
                // then
                expectation.fulfill()
            }, onError: { error in
                // then
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_getTracks_givenValidJSON() {
        do {
            // given
            let data = try Data.fromJSON(fileName: "SampleData")
            let response = try JSONDecoder().decode(Response.self, from: data)
            let trackDTOs = response.results
            let tracks = trackDTOs.compactMap { $0.asDomain() }
            
            print("tracks.count", tracks.count)
            
            // then
            XCTAssertFalse(trackDTOs.isEmpty, "trackDTOs is empty.")
            XCTAssertFalse(tracks.isEmpty, "tracks is empty.")
        } catch {
            // then
            XCTFail(error.localizedDescription)
        }
    }
}
