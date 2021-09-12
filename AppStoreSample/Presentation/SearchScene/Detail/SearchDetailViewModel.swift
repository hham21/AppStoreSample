//
//  SearchDetailViewModel.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/07.
//

import Domain
import RxSwift
import RxCocoa
import RxFlow

final class DetailViewModel: ViewModel {
    enum Input {
        case initialData(Track)
    }
    
    struct Output {
        var dataSource: [SearchDetail.Model]?
        var artWorkURL: String?
    }
    
    var input: PublishRelay<Input> = .init()
    internal var mutation: PublishRelay<Input> = .init()
    var output: BehaviorRelay<Output> = .init(value: .init())
    
    internal let disposeBag: DisposeBag = .init()
    
    init(with data: Track) {
        bind()
        input.accept(.initialData(data))
    }
    
    internal func reduce(mutation: Input) -> Observable<Output> {
        var newOutput = output.value
        switch mutation {
        case .initialData(let track):
            let items = SearchDetail.DetailViewItemModel().parse(data: track)
            let dataSource = [SearchDetail.Model(model: .none, items: items)]
            newOutput.dataSource = dataSource
            newOutput.artWorkURL = track.artworkURL
        }
        return .just(newOutput)
    }
    
    func getArtworkURL() -> String? {
        output.value.artWorkURL
    }
}
