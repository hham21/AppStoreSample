//
//  SearchDetailViewModel.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/07.
//

import Domain
import RxSwift
import RxCocoa

final class DetailViewModel {
    private let disposeBag: DisposeBag = .init()
    
    let dataSource: Driver<[SearchDetail.Model]>
    private var artworkURL: BehaviorRelay<String?> = .init(value: nil)
    
    init(with data: Observable<Track>) {
        let initialData = data
            .share()
        
        initialData
            .map { $0.artworkURL }
            .bind(to: artworkURL)
            .disposed(by: disposeBag)
        
        let dataSource = initialData
            .map(SearchDetail.DetailViewItemModel().parse)
            .map { [SearchDetail.Model(model: .none, items: $0)] }
            .asDriver(onErrorJustReturn: [])
        
        self.dataSource = dataSource
    }
    
    func getArtworkURL() -> String? {
        artworkURL.value
    }
}
