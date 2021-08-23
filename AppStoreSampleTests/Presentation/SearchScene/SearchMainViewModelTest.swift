//
//  SearchMainViewModelTest.swift
//  AppStoreSampleTests
//
//  Created by Hyoungsu Ham on 2021/08/24.
//

@testable import AppStoreSample
@testable import Domain
@testable import Data
import XCTest
import RxSwift

class SearchMainViewModelTest: XCTestCase {
    var mockTrack: Track!
    var sut: SearchMainViewModel!
    var disposeBag: DisposeBag = .init()
    
    override func setUp() {
        super.setUp()
        
        do {
            let data = try Data.fromJSON(fileName: "SampleTrack")
            let trackDTO = try JSONDecoder().decode(TrackDTO.self, from: data)
            mockTrack = trackDTO.asDomain()
            
            let dataSource: KeywordDataSource = MockKeywordDataSource()
            let repo: KeywordRepository = KeywordRepositoryImpl(localDataSource: dataSource)
            let useCase: KeywordUseCase = KeywordUseCaseImpl(repo: repo)
            sut = SearchMainViewModel(keywordUseCase: useCase)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    override func tearDown() {
        mockTrack = nil
        sut = nil
        disposeBag = .init()
        super.tearDown()
    }
    
    func test_output_givenInitialLoad() {
        let expectaion: XCTestExpectation = .init()
        
        // when
        sut.output.dataSource
            .drive(onNext: { _ in
                // then
                expectaion.fulfill()
            })
            .disposed(by: disposeBag)
        
        sut.input.initialLoad.accept(())
        
        wait(for: [expectaion], timeout: 5)
    }
    
    func test_output_givenReload() {
        let expectaion: XCTestExpectation = .init()
        
        // when
        sut.output.dataSource
            .drive(onNext: { _ in
                // then
                expectaion.fulfill()
            })
            .disposed(by: disposeBag)
        
        sut.input.reload.accept(())
        
        wait(for: [expectaion], timeout: 5)
    }
    
    func test_output_givenTrackSelected() {
        let expectaion: XCTestExpectation = .init()
        
        // when
        sut.steps
            .subscribe(onNext: { step in
                print("steps.onNext: ", step)
                expectaion.fulfill()
            })
            .disposed(by: disposeBag)
        
        sut.input.trackSelected.accept(mockTrack)
        
        wait(for: [expectaion], timeout: 5)
    }
}
