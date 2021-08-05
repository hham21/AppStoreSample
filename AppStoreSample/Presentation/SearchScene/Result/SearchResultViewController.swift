//
//  SearchResultViewController.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/02.
//

import UIKit
import Domain
import RxSwift
import RxCocoa
import Reusable

protocol SearchResultViewControllerDelegate: AnyObject {
    func searchResultDidSelectTrack(with data: Track)
    func searchResultScrollViewWillBeginDragging()
    func searchResultDidSelectKeyword(_ keyword: String)
}

final class SearchResultViewController: UIViewController, StoryboardBased {
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: SearchResultViewModel! = nil
    private lazy var dataSource: SearchResult.DataSource = createDataSource()
    weak var delegate: SearchResultViewControllerDelegate?
    private var disposeBag: DisposeBag = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributes()
        bind()
    }
    
    private func setAttributes() {
        setTableView()
        registerCells()
    }
    
    private func setTableView() {
        tableView.delegate = self
    }
    
    private func registerCells() {
        tableView.register(cellType: SearchRecentKeywordCell.self)
        tableView.register(cellType: SearchTrackCell.self)
    }
    
    private func bind() {
        bindDataSource()
        bindError()
    }
    
    private func bindDataSource() {
        viewModel.output.dataSource
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func bindError() {
        viewModel.output.error
            .emit(onNext: { error in
                log.error(<#T##message: Any##Any#>)
            })
            .disposed(by: disposeBag)
    }
    
    private func createDataSource() -> SearchResult.DataSource {
        .init(configureCell: { ds, tv, indexPath, data -> UITableViewCell in
            switch data {
            case .recentKeyword(let data):
                let cell: SearchRecentKeywordCell = tv.dequeueReusableCell(for: indexPath)
                cell.configure(with: data)
                return cell
            case .track(let data):
                let cell: SearchTrackCell = tv.dequeueReusableCell(for: indexPath)
                cell.configure(with: data)
                cell.delegate = self
                return cell
            }
        })
    }
    
    private func showDetailViewController(_ trackId: Int) {
//        guard let data = viewModel.getTrack(trackId) else {
//            return
//        }
//        delegate?.showDetailViewController(with: data)
    }
}

// MARK: - UITableViewDelegate

extension SearchResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch dataSource[indexPath] {
        case .recentKeyword:
            return SearchResult.Const.recentKeywordCellHeight
        case .track:
            return SearchResult.Const.trackCellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch dataSource[indexPath] {
        case .recentKeyword(let text):
            viewModel.input.searchButtonTapped.accept(text)
            delegate?.searchResultDidSelectKeyword(text)
            tableView.deselectRow(at: indexPath, animated: true)
        case .track(let data):
            showDetailViewController(data.trackId)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.searchResultScrollViewWillBeginDragging()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.prepareForReuse()
    }
}

extension SearchResultViewController {
    func updateSearchResult(text: String) {
        viewModel.input.searchBarTextUpdated.accept(text)
    }
    
    func searchQuery(text: String) {
        viewModel.input.searchButtonTapped.accept(text)
    }
}

extension SearchResultViewController {
    static func create(viewModel: SearchResultViewModel) -> SearchResultViewController {
        let vc: SearchResultViewController = .instantiate()
        vc.viewModel = viewModel
        return vc
    }
}

// MARK: - SearchTrackCellDelegate

extension SearchResultViewController: SearchTrackCellDelegate {
    func openButtonTapped(cell: SearchTrackCell) {
        guard let indexPath: IndexPath = tableView.indexPath(for: cell) else {
            return
        }
        guard case let .track(data) = dataSource[indexPath] else {
            return
        }
        showDetailViewController(data.trackId)
    }
}
