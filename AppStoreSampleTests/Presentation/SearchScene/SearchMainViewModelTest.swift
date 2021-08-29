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
            // given
            let data = try Data.fromJSON(fileName: "SampleTrack")
            let trackDTO = try JSONDecoder().decode(TrackDTO.self, from: data)
            mockTrack = trackDTO.asDomain()
            
            let dataSource: KeywordDataSource = MockKeywordDataSource()
            let repo: KeywordRepository = KeywordRepositoryImpl(localDataSource: dataSource)
            let useCase: GetKeywordUseCase = GetKeywordUseCaseImple(keywordRepo: repo)
            sut = SearchMainViewModel(getKeywordUseCase: useCase)
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
    
    func test_output_whenInitialLoad() {
        let expectaion: XCTestExpectation = .init()
        
        sut.output.dataSource
            .drive(onNext: { _ in
                // then
                expectaion.fulfill()
            })
            .disposed(by: disposeBag)
        
        // when
        sut.input.initialLoad.accept(())
        
        wait(for: [expectaion], timeout: 5)
    }
    
    func test_output_whenReload() {
        let expectaion: XCTestExpectation = .init()
        
        sut.output.dataSource
            .drive(onNext: { _ in
                // then
                expectaion.fulfill()
            })
            .disposed(by: disposeBag)
        
        // when
        sut.input.reload.accept(())
        
        wait(for: [expectaion], timeout: 5)
    }
    
    func test_output_whenTrackSelected() {
        let expectaion: XCTestExpectation = .init()
        
        // given
        sut.output.dataSource.drive().disposed(by: disposeBag)
        
        sut.steps
            .subscribe(onNext: { step in
                print("steps.onNext: ", step)
                // then
                expectaion.fulfill()
            }, onError: { error in
                // then
                XCTFail(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        // when
        sut.input.trackSelected.accept(mockTrack)
        
        wait(for: [expectaion], timeout: 5)
    }
}
