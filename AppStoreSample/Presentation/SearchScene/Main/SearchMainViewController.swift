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
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: SearchMainViewModel! = nil
    private lazy var dataSource: SearchMain.DataSource = createDataSource()
    var searchResultVC: SearchResultViewController!
    private lazy var searchController: UISearchController = .init(searchResultsController: searchResultVC)
    private let disposeBag: DisposeBag = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributes()
        bind()
        viewModel.action.onNext(.initialLoad)
    }
    
    private func setAttributes() {
        setNavigationTabBarItem()
        setSearchController()
        setNavigationBar()
        setNavigationItem()
        setTableView()
        registerCells()
    }
    
    private func setNavigationTabBarItem() {
        let searchImage: UIImage = Asset.search.image
        let homeItem: UITabBarItem = .init(title: "Search", image: searchImage, selectedImage: nil)
        navigationController?.tabBarItem = homeItem
    }
    
    private func setSearchController() {
        let placeholder = SearchMain.Const.searchBarPlaceHodlerText
        let cancelbuttonTitle = SearchMain.Const.searchBarCancelButtonTitle
        let cancelButtonKey = SearchMain.Const.searchBarCancelButtonKey
        searchController.searchBar.placeholder = placeholder
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.setValue(cancelbuttonTitle, forKey: cancelButtonKey)
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setNavigationItem() {
        navigationItem.title = SearchMain.Const.title
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        navigationController?.navigationBar.sizeToFit()
        definesPresentationContext = true
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    
    private func registerCells() {
        tableView.register(cellType: MainRecentKeywordCell.self)
        tableView.register(cellType: MainHeaderCell.self)
    }
    
    private func bind() {
        bindDataSource()
        bindError()
    }
    
    private func bindDataSource() {
        viewModel.state.compactMap { $0.dataSource }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func bindError() {
        viewModel.state.compactMap { $0.error }
            .subscribe(onNext: { error in
                log.debug(error)
            })
            .disposed(by: disposeBag)
    }
    
    private func createDataSource() -> SearchMain.DataSource {
        .init(configureCell: { _, tv, indexPath, item -> UITableViewCell in
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
            return SearchMain.Const.mainHeaderCellHeight
        case .recentKeyword:
            return SearchMain.Const.recentKeywordCellHeight
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
        searchResultScrollViewWillBeginDragging()
    }
}

// MARK: - UISearchResultsUpdating

extension SearchMainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text: String = searchController.searchBar.text else {
            return
        }
        viewModel.action.onNext(.reload)
        searchResultVC.updateSearchResult(text: text.lowercased())
    }
}

// MARK: - UISearchBarDelegate

extension SearchMainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchResultScrollViewWillBeginDragging()
        
        if let text = searchBar.text {
            searchResultVC.searchQuery(text: text)
        }
    }
}

// MARK: - SearchViewControllerDelegate

extension SearchMainViewController: SearchResultViewControllerDelegate {
    func searchResultDidSelectTrack(with data: Track) {
        viewModel.action.onNext(.trackSelected(data))
    }
    
    func searchResultScrollViewWillBeginDragging() {
        navigationItem.searchController?.searchBar.resignFirstResponder()
    }
    
    func searchResultDidSelectKeyword(_ keyword: String) {
        inputTextToSearchBar(keyword)
        searchResultScrollViewWillBeginDragging()
    }
}

// MARK: - Preperation

extension SearchMainViewController {
    static func create(with viewModel: SearchMainViewModel, searchResultVC: SearchResultViewController) -> SearchMainViewController {
        let vc: SearchMainViewController = SearchMainViewController.instantiate()
        vc.viewModel = viewModel
        vc.searchResultVC = searchResultVC
        searchResultVC.delegate = vc
        return vc
    }
}
