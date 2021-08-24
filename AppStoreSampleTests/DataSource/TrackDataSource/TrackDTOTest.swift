//
//  TrackDTOTest.swift
//  AppStoreSampleTests
//
//  Created by Hyoungsu Ham on 2021/08/24.
//

@testable import AppStoreSample
@testable import Data
@testable import Domain
import XCTest

class TrackDTOTest: XCTestCase {
    var sut: TrackDTO!
    var dictionary: NSDictionary!
    
    override func setUp() {
        super.setUp()
        
        do {
            // given
            let data = try Data.fromJSON(fileName: "SampleTrack")
            let trackDTO = try JSONDecoder().decode(TrackDTO.self, from: data)
            sut = trackDTO
            dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
        } catch {
            // then
            XCTFail(error.localizedDescription)
        }
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_conformsTo_Decodable() {
        // then
        XCTAssertTrue((sut as Any) is Decodable)
    }
    
    func test_conformsTo_asDomain() {
        // then
        XCTAssertTrue((sut.asDomain() as Any) is Track)
    }
    
    func test_decodable_sets_trackId() {
        // then
        XCTAssertEqual(sut.trackId, dictionary["trackId"] as! Int)
    }
    
    func test_decodable_sets_trackName() {
        // then
        XCTAssertEqual(sut.trackName, dictionary["trackName"] as! String)
    }
    
    func test_decodable_sets_sellerName() {
        // then
        XCTAssertEqual(sut.sellerName, dictionary["sellerName"] as! String)
    }
    
    func test_decodable_sets_artistName() {
        // then
        XCTAssertEqual(sut.artistName, dictionary["artistName"] as! String)
    }
}
