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
import RxFlow

final class SearchMainViewModel: ViewModelType, Stepper {
    struct Input {
        let initialLoad: PublishRelay<Void> = .init()
        let reload: PublishRelay<Void> = .init()
        let trackSelected: PublishRelay<Track> = .init()
    }
    
    struct Output {
        let dataSource: Driver<[SearchMain.Model]>
        let error: Signal<Error>
    }
    
    lazy var input: Input = .init()
    lazy var output: Output = mutate(input: input)
    
    var steps: PublishRelay<Step> = .init()
    
    private let getKeywordUseCase: GetKeywordUseCase
    private let disposeBag: DisposeBag = .init()
    
    init(getKeywordUseCase: GetKeywordUseCase) {
        self.getKeywordUseCase = getKeywordUseCase
    }
    
    func mutate(input: Input) -> Output {
        
        input.trackSelected
            .compactMap { AppStep.searchDetail(track: $0) }
            .bind(to: steps)
            .disposed(by: disposeBag)

        // getKeywords
        let getKeywords = Observable
            .merge(
                input.initialLoad.asObservable(),
                input.reload.asObservable()
            )
            .withUnretained(self)
            .flatMapLatest {
                $0.0.getKeywordUseCase.getKeywords()
            }
            .materialize()
            .share()
        
        let getKeywordsData = getKeywords
            .compactMap { $0.element }
            .compactMap(SearchMain().buildModel)
        
        let getKeywordsError = getKeywords
            .compactMap { $0.error }
        
        // Merge DataSources
        let dataSource = Observable
            .merge(getKeywordsData)
            .asDriver(onErrorJustReturn: [])
        
        // Merge Errors
        let error = Observable
            .merge(getKeywordsError)
            .asSignal(onErrorJustReturn: RxError.unknown)
        
        return Output(dataSource: dataSource, error: error)
    }
}
