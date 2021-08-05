//
//  SearchMainViewModel.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/02.
//

import Domain
import RxSwift
import RxCocoa
import RxDataSources

final class SearchMainViewModel: ViewModelType {
    struct Input {
        let initialLoad: PublishRelay<Void> = .init()
        let reload: PublishRelay<Void> = .init()
    }
    
    struct Output {
        let dataSource: Driver<[SearchMain.Model]>
        let error: Signal<Error>
    }
    
    lazy var input: Input = .init()
    lazy var output: Output = mutate(input: input)
    
    private let keywordUseCase: KeywordUseCase
    private let disposeBag: DisposeBag = .init()
    
    init(keywordUseCase: KeywordUseCase) {
        self.keywordUseCase = keywordUseCase
    }
    
    func mutate(input: Input) -> Output {
        let getKeywords = getKeywords()
        let dataSource = getKeywords.data.asDriver(onErrorJustReturn: [])
        let error = getKeywords.error.asSignal(onErrorJustReturn: RxError.unknown)
        
        return Output(dataSource: dataSource, error: error)
    }
    
    private func getKeywords() -> (data: Observable<[SearchMain.Model]>, error: Observable<Error>) {
        let getKeywords = Observable
            .merge(
                input.initialLoad.asObservable(),
                input.reload.asObservable()
            )
            .withUnretained(self)
            .flatMapLatest {
                $0.0.keywordUseCase.getKeywords()
            }
            .materialize()
            .share()
        
        let getKeywordsData = getKeywords
            .compactMap { $0.element }
            .compactMap(SearchMain().buildModel)
        
        let getKeywordsError = getKeywords
            .compactMap { $0.error }
        
        return (getKeywordsData, getKeywordsError)
    }
    
//    func mutate(input: Input) -> Output {
//        let dataSource = createDataSource(input: input)
//        return Output(dataSource: dataSource)
//    }
//
//    private func createDataSource(input: Input) -> Driver<[SearchMain.Model]> {
//        Observable
//            .merge(
//                input.initialLoad.asObservable(),
//                input.reload.asObservable()
//            )
//            .withUnretained(self)
//            .flatMapLatest {
//                $0.0.keywordUseCase.getKeywords()
//            }
//            .compactMap(SearchMain().buildModel)
//            .asDriver(onErrorJustReturn: [])
//    }
}
