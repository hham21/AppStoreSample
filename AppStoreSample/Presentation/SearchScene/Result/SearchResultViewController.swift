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
    func showDetailViewController(with data: Track)
    func resignSearchBarFirstResponder()
    func didTapRecentKeyword(_ keyword: String)
}

final class SearchResultViewController: UIViewController, StoryboardBased {
    enum Const {
        static let recentKeywordCellHeight: CGFloat = 44.0
        static let trackCellHeight: CGFloat = 280.0
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel: SearchResultViewModel = .init()
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
        viewModel.output.dataSource
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
//        viewModel.errorMessage
//            .delay(.milliseconds(500))
//            .emit(onNext: { description in
//                Toast(text: description, duration: 1.0).showCenter()
//            })
//            .disposed(by: disposeBag)
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
            return Const.recentKeywordCellHeight
        case .track:
            return Const.trackCellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch dataSource[indexPath] {
        case .recentKeyword(let text):
            viewModel.input.searchButtonTapped.accept(text)
            delegate?.didTapRecentKeyword(text)
            tableView.deselectRow(at: indexPath, animated: true)
        case .track(let data):
            showDetailViewController(data.trackId)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.resignSearchBarFirstResponder()
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
    static func create(delegate: SearchResultViewControllerDelegate) -> SearchResultViewController {
        let vc: SearchResultViewController = .instantiate()
        vc.delegate = delegate
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
