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
