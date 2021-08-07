//
//  SearchDetailViewController.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/07.
//

import UIKit
import Domain
import RxSwift
import Reusable

final class SearchDetailViewController: UIViewController, StoryboardBased {
    struct Const {
        static let headerCellHeight: CGFloat = 150.0
        static let horizontalInfoCellHeight: CGFloat = 90.0
        static let releaseNoteCellHeight: CGFloat = 140.0
        static let descriptionCellHeight: CGFloat = 116.0
        static let defaultEstimatedHeight: CGFloat = 150.0
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: DetailViewModel!
    private var expandedRow: [IndexPath] = []
    private var isArtworkDisplaying: Bool = false
    
    private lazy var dataSource: SearchDetail.DataSource = createDataSource()
    private let disposeBag: DisposeBag = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributes()
        bind()
    }
    
    private func setAttributes() {
        tableView.delegate = self
        tableView.decelerationRate = .init(rawValue: 0.994)
        navigationItem.largeTitleDisplayMode = .never
        registerCells()
    }
    
    private func registerCells() {
        tableView.register(cellType: DetailHeaderCell.self)
        tableView.register(cellType: DetailHorizontalInfoCell.self)
        tableView.register(cellType: DetailReleaseNotesCell.self)
        tableView.register(cellType: DetailPreviewCell.self)
        tableView.register(cellType: DetailDescriptionCell.self)
        tableView.register(cellType: DetailSellerInfoCell.self)
        tableView.register(cellType: DetailVerticalInfoCell.self)
    }
    
    private func bind() {
        viewModel.dataSource
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func createDataSource() -> SearchDetail.DataSource {
        .init(configureCell: { [weak self] ds, tv, indexPath, item -> UITableViewCell in
            guard let self = self else {
                return UITableViewCell()
            }
            
            switch item {
            case .header(let data):
                let cell: DetailHeaderCell = tv.dequeueReusableCell(for: indexPath)
                cell.configure(with: data)
                return cell
            case .horizaontalInfo(let data):
                let cell: DetailHorizontalInfoCell = tv.dequeueReusableCell(for: indexPath)
                cell.configure(with: data)
                return cell
            case .releaseNotes(let data):
                let cell: DetailReleaseNotesCell = tv.dequeueReusableCell(for: indexPath)
                cell.delegate = self
                var dataModified = data
                dataModified.collapsed = self.expandedRow.contains(indexPath)
                cell.configure(with: dataModified)
                return cell
            case .preview(let data):
                let cell: DetailPreviewCell = tv.dequeueReusableCell(for: indexPath)
                cell.configure(with: data)
                return cell
            case .description(let data):
                let cell: DetailDescriptionCell = tv.dequeueReusableCell(for: indexPath)
                cell.delegate = self
                var dataModified = data
                dataModified.collapsed = self.expandedRow.contains(indexPath)
                cell.configure(with: dataModified)
                return cell
            case .sellerInfo(let data):
                let cell: DetailSellerInfoCell = tv.dequeueReusableCell(for: indexPath)
                cell.configure(with: data)
                return cell
            case .verticalInfo(let data):
                let cell: DetailVerticalInfoCell = tv.dequeueReusableCell(for: indexPath)
                cell.configure(with: data)
                return cell
            }
        })
    }
}

// MARK: - UITableViewDelegate

extension SearchDetailViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        holdFristCellPositionWhenScrollingDown(scrollView)
        setTitleViewImage(scrollView)
    }
    
    private func holdFristCellPositionWhenScrollingDown(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.y < 0 else {
            return
        }
        guard let cell = tableView.cellForRow(at: .init(row: 0, section: 0)) else {
            return
        }
        cell.frame.origin.y = tableView.contentOffset.y
    }
    
    private func setTitleViewImage(_ scollView: UIScrollView) {
        guard let firstCell = tableView.cellForRow(at: .init(item: 0, section: 0)) as? DetailHeaderCell else {
            return
        }
        
        let openButtonFrame = firstCell.openButton.bounds
        let coord = firstCell.openButton.convert(openButtonFrame, to: self.view)
        
        if coord.origin.y <= scollView.contentOffset.y {
            guard navigationItem.titleView == nil else {
                return
            }
            guard let artworkURL = viewModel.getArtworkURL() else {
                return
            }
            
            let containerView: UIView = .init(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
            let imageView: UIImageView = .init(frame: CGRect(x: 0, y: 7, width: 28, height: 28))
            
            imageView.contentMode = .scaleAspectFit
            imageView.layer.cornerRadius = 5
            imageView.layer.borderWidth = 0.2
            imageView.layer.masksToBounds = true
            imageView.layer.borderColor = UIColor.systemGray.cgColor
            
            imageView.kf.setImage(with: URL(string: artworkURL))
            
            containerView.addSubview(imageView)
            containerView.alpha = 0.0

            navigationItem.titleView = containerView
        
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveLinear]) { [weak containerView, weak imageView] in
                containerView?.alpha = 1.0
                imageView?.frame.origin.y = 0
            }
        } else {
            navigationItem.titleView = nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch dataSource[indexPath] {
        case .header:
            return Const.headerCellHeight
        case .horizaontalInfo:
            return Const.horizontalInfoCellHeight
        case .releaseNotes:
            if expandedRow.contains(indexPath) {
                return UITableView.automaticDimension
            } else {
                return Const.releaseNoteCellHeight
            }
        case .description:
            if expandedRow.contains(indexPath) {
                return UITableView.automaticDimension
            } else {
                return Const.descriptionCellHeight
            }
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return Const.defaultEstimatedHeight
    }
}

extension SearchDetailViewController {
    static func create(with data: Track) -> SearchDetailViewController {
        let vc: SearchDetailViewController = SearchDetailViewController.instantiate()
        let viewModel: DetailViewModel = .init(with: .just(data))
        vc.viewModel = viewModel
        return vc
    }
}

// MARK: - DetailReleaseNotesCellDelegate, DetailDescriptionCellDelegate

extension SearchDetailViewController: DetailReleaseNotesCellDelegate, DetailDescriptionCellDelegate {
    func moreButtonTapped(_ cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        expandedRow.append(indexPath)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
