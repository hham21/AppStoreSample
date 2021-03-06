//
//  SearchResultViewModelTest.swift
//  AppStoreSampleTests
//
//  Created by Hyoungsu Ham on 2021/08/24.
//

@testable import AppStoreSample
@testable import Domain
@testable import Data
import XCTest
import RxSwift

class SearchResultViewModelTest: XCTestCase {
    var sut: SearchResultViewModel!
    var disposeBag: DisposeBag = .init()
    
    override func setUp() {
        super.setUp()
        
        let keywordDataSource: KeywordDataSource = MockKeywordDataSource()
        let keywordRepo: KeywordRepository = KeywordRepositoryImpl(localDataSource: keywordDataSource)
        let keywordUseCase: GetKeywordUseCase = GetKeywordUseCaseImple(keywordRepo: keywordRepo)
        
        let trackDataSource: TrackDataSource = MockTrackDataSource()
        let trackRepo: TrackRepository = TrackRepositoryImpl(remoteDataSource: trackDataSource)
        let searchTrackUseCase: SearchTrackUseCase = SearchTrackUseCaseImpl(trackRepo: trackRepo, keywordRepo: keywordRepo)
        
        // given
        sut = SearchResultViewModel(getKeywordUseCase: keywordUseCase, searchTrackUseCase: searchTrackUseCase)
    }
    
    override func tearDown() {
        sut = nil
        disposeBag = .init()
        super.tearDown()
    }
    
    func test_output_whenSearchBarTextUpdated() {
        let expectaion: XCTestExpectation = .init()
        
        sut.output.dataSource
            .drive(onNext: { dataSource in
                print("dataSource.onNext: ", dataSource)
                // then
                expectaion.fulfill()
            })
            .disposed(by: disposeBag)
        
        // when
        sut.input.searchBarTextUpdated.accept("스무디")
        
        wait(for: [expectaion], timeout: 5)
    }
    
    func test_output_whenSearchButtonTapped() {
        let expectaion: XCTestExpectation = .init()
        
        sut.output.dataSource
            .drive(onNext: { dataSource in
                print("dataSource.onNext: ", dataSource.count)
                // then
                expectaion.fulfill()
            })
            .disposed(by: disposeBag)
        
        // when
        sut.input.searchButtonTapped.accept("스무디")
        
        wait(for: [expectaion], timeout: 5)
    }
}
