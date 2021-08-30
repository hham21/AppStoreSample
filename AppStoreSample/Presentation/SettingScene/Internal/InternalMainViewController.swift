//
//  InternalMainViewController.swift
//  AppStoreSample
//
//  Created by Jinwoo Kim on 8/30/21.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import Reusable

final class InternalMainViewController: UIViewController, StoryboardBased {
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate(set) var viewModel: InternalMainViewModel! = nil
    private lazy var dataSource: InternalMain.DataSource = createDataSource()
    private let disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        registerCells()
        bind()
    }
    
    private func setTableView() {
        tableView.delegate = self
    }
    
    private func registerCells() {
        // UITableViewCell 기본 Cell은 Reusable을 지원하지 않음 - legacy 방법으로
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    private func bind() {
        viewModel.output
            .errorOccured
            .asObservable()
            .subscribe(onNext: { error in
                JBLog.print(.error(error))
            })
            .disposed(by: disposeBag)
        
        viewModel.output
            .requestedLogFileUrl
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { (weakSelf, url) in
                weakSelf.presentActivityController(with: url)
            })
            .disposed(by: disposeBag)
        
        bindDataSource()
    }
    
    private func bindDataSource() {
        viewModel.output.dataSource
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func createDataSource() -> InternalMain.DataSource {
        .init { [weak self] _, tv, indexPath, item -> UITableViewCell in
            guard let self = self else { return .init() }
            let cell = tv.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
            cell.textLabel?.text = item.title
            
            switch item {
            case .isLoggingToFileEnabled(let value):
                let switchView = UISwitch()
                switchView.isOn = value
                switchView.addTarget(self, action: #selector(self.loggingToFileEnabledChanged(_:)), for: .valueChanged)
                cell.accessoryView = switchView
            default:
                break
            }
            
            return cell
        }
    }
    
    @objc private func loggingToFileEnabledChanged(_ sender: UISwitch) {
        viewModel.input.changeLoggingToFileEnabled.accept(sender.isOn)
    }
    
    private func presentActivityController(with url: URL) {
        let ac = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        let pc = ac.popoverPresentationController
        pc?.sourceView = view
        present(ac, animated: true, completion: nil)
    }
}

// MARK: - Preperation

extension InternalMainViewController {
    static func create(with viewModel: InternalMainViewModel) -> InternalMainViewController {
        let vc: InternalMainViewController = .instantiate()
        vc.viewModel = viewModel
        return vc
    }
}

// MARK: - UITableViewDelegate

extension InternalMainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let item = dataSource[indexPath]
        
        switch item {
        case .shareLogFile:
            return true
        default:
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        let item = dataSource[indexPath]
        
        switch item {
        case .shareLogFile:
            viewModel.input.requestLogFileUrl.accept(())
        default:
            break
        }
    }
}
