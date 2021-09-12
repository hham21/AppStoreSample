//
//  SettingMainViewController.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/17.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import Reusable

final class SettingMainViewController: UIViewController, StoryboardBased {
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate(set) var viewModel: SettingMainViewModel! = nil
    private lazy var dataSource: SettingMain.DataSource = createDataSource()
    private let disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributes()
        setTableView()
        registerCells()
        bind()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        
        switch motion {
        case .motionShake:
            viewModel.input.accept(.shakeDetected)
        default:
            break
        }
    }
    
    private func setAttributes() {
        setNavigationTabBarItem()
    }
    
    private func setTableView() {
        tableView.delegate = self
    }
    
    private func registerCells() {
        // UITableViewCell 기본 Cell은 Reusable을 지원하지 않음 - legacy 방법으로
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    private func setNavigationTabBarItem() {
        let settingImage: UIImage = Asset.settings.image
        let settingItem: UITabBarItem = .init(title: "Setting", image: settingImage, selectedImage: nil)
        navigationController?.tabBarItem = settingItem
    }
    
    private func bind() {
        bindOutput()
    }
    
    private func bindOutput() {
        viewModel.output.compactMap { $0.dataSource }
            .debug("bindOutput")
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.output.compactMap { $0.signedOut }
            .subscribe(onNext: { _ in
                log.debug("signed out")
            })
            .disposed(by: disposeBag)
    }
    
    private func createDataSource() -> SettingMain.DataSource {
        .init { _, tv, indexPath, item -> UITableViewCell in
            let cell = tv.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
            cell.textLabel?.text = item.title
            
            return cell
        }
    }
}

// MARK: - Preperation

extension SettingMainViewController {
    static func create(with viewModel: SettingMainViewModel) -> SettingMainViewController {
        let vc: SettingMainViewController = .instantiate()
        vc.viewModel = viewModel
        return vc
    }
}

// MARK: - UITableViewDelegate

extension SettingMainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        let item = dataSource[indexPath]
        
        switch item {
        case .push(let desination):
            switch desination {
            case .internal:
                viewModel.input.accept(.didSelectInternal)
            }
        case .logout:
            viewModel.input.accept(.signOutTapped)
        }
    }
}
