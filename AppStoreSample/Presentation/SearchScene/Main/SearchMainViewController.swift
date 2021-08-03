//
//  MainViewController.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/02.
//

import UIKit
import Domain
import RxSwift
import Reusable

final class SearchMainViewController: UIViewController, StoryboardBased {
    enum Const {
        static let title: String = "검색"
        static let searchBarCancelButtonKey: String = "cancelButtonText"
        static let searchBarCancelButtonTitle: String = "취소"
        static let searchBarPlaceHodlerText: String = "게임, 앱, 스토리 등"
        static let mainHeaderCellHeight: CGFloat = 66.0
        static let recentKeywordCellHeight: CGFloat = 44.0
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: SearchMainViewModel! = nil
    private lazy var dataSource: SearchMain.DataSource = createDataSource()
    private let searchResultVC: SearchResultViewController = .instantiate()
    private lazy var searchController: UISearchController = .init(searchResultsController: searchResultVC)
    private let disposeBag: DisposeBag = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributes()
        bind()
    }
    
    private func setAttributes() {
        setSearchController()
        setNavigationItem()
        setTableView()
        registerCells()
    }
    
    private func setSearchController() {
        let placeholder = Const.searchBarPlaceHodlerText
        let cancelbuttonTitle = Const.searchBarCancelButtonTitle
        let cancelButtonKey = Const.searchBarCancelButtonKey
        searchController.searchBar.placeholder = placeholder
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.setValue(cancelbuttonTitle, forKey: cancelButtonKey)
    }
    
    private func setNavigationItem() {
        navigationItem.title = Const.title
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        navigationController?.navigationBar.sizeToFit()
        definesPresentationContext = true
    }
    
    private func setTableView() {
        tableView.delegate = self
    }
    
    private func registerCells() {
        tableView.register(cellType: MainRecentKeywordCell.self)
        tableView.register(cellType: MainHeaderCell.self)
    }
    
    private func bind() {
        bindDataSource()
    }
    
    private func bindDataSource() {
        viewModel.output.dataSource
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func createDataSource() -> SearchMain.DataSource {
        .init(configureCell: { ds, tv, indexPath, item -> UITableViewCell in
            switch item {
            case .header:
                let cell: MainHeaderCell = tv.dequeueReusableCell(for: indexPath)
                return cell
            case .recentKeyword(let data):
                let cell: MainRecentKeywordCell = tv.dequeueReusableCell(for: indexPath)
                cell.configure(with: data)
                return cell
            }
        })
    }
    
    private func foldSearchBar() {
        guard let searchController = navigationItem.searchController else {
            return
        }
        searchController.isActive = true
    }
}

// MARK: - UITableViewDelegate

extension SearchMainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch dataSource[indexPath] {
        case .header:
            return Const.mainHeaderCellHeight
        case .recentKeyword:
            return Const.recentKeywordCellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch dataSource[indexPath] {
        case .recentKeyword(let data):
            inputTextToSearchBar(data)
            foldSearchBar()
            searchResultVC.searchQuery(text: data)
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            return
        }
    }
    
    private func inputTextToSearchBar(_ text: String) {
        navigationItem.searchController?.searchBar.text = text
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        resignSearchBarFirstResponder()
    }
}

// MARK: - UISearchResultsUpdating

extension SearchMainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text: String = searchController.searchBar.text else {
            return
        }
        viewModel.input.reload.accept(())
        searchResultVC.updateSearchResult(text: text.lowercased())
    }
}

// MARK: - UISearchBarDelegate

extension SearchMainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        resignSearchBarFirstResponder()
        
        if let text = searchBar.text {
            searchResultVC.searchQuery(text: text)
        }
    }
}


// MARK: - SearchViewControllerDelegate

extension SearchMainViewController: SearchResultViewControllerDelegate {
    func showDetailViewController(with data: Track) {
        guard let navigationController = navigationController else {
            return
        }
//        let vc: DetailViewController = .create(with: data)
//        navigationController.pushViewController(vc, animated: true)
    }
    
    func resignSearchBarFirstResponder() {
        navigationItem.searchController?.searchBar.resignFirstResponder()
    }
    
    func didTapRecentKeyword(_ keyword: String) {
        inputTextToSearchBar(keyword)
        resignSearchBarFirstResponder()
    }
}

// MARK: - Preperation

extension SearchMainViewController {
    static func create(with viewModel: SearchMainViewModel) -> SearchMainViewController {
        let vc: SearchMainViewController = SearchMainViewController.instantiate()
        vc.viewModel = viewModel
        return vc
    }
}
