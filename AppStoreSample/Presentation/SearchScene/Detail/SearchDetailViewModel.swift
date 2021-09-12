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
import ReactorKit

final class DetailViewModel: Reactor {
    enum Action {
        case initialData(Track)
    }
    
    struct State {
        var dataSource: [SearchDetail.Model] = .init()
        var artWorkURL: String?
    }
    
    let initialState: State = .init()
    let disposeBag: DisposeBag = .init()
    
    init(with data: Track) {
        action.onNext(.initialData(data))
    }
    
    func reduce(state: State, mutation: Action) -> State {
        var newState = state
        switch mutation {
        case .initialData(let track):
            let items = SearchDetail.DetailViewItemModel().parse(data: track)
            let dataSource = [SearchDetail.Model(model: .none, items: items)]
            newState.dataSource = dataSource
            newState.artWorkURL = track.artworkURL
        }
        return newState
    }
    
    func getArtworkURL() -> String? {
        return currentState.artWorkURL
    }
}
