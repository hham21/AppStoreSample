//
//  SettingViewController.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/17.
//

import UIKit
import Reusable
import RxCocoa
import RxSwift

final class SettingViewController: UIViewController, StoryboardBased {
    
    let viewModel: SettingViewModel = .init()
    
    private let disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setAttributes()
    }
    
    private func setAttributes() {
        setNavigationTabBarItem()
    }
    
    private func setNavigationTabBarItem() {
        let settingImage: UIImage = Asset.settings.image
        let settingItem: UITabBarItem = .init(title: "Setting", image: settingImage, selectedImage: nil)
        navigationController?.tabBarItem = settingItem
    }
    
    private func bind() {
        viewModel.output
            .signedOut
            .subscribe(onNext: {
                log.debug("signed out")
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func signOutTapped(_ sender: UIButton) {
        viewModel.input.signOutTapped.accept(())
    }
}
