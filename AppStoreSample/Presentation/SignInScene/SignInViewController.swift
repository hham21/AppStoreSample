//
//  SignInViewController.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/19.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable

final class SignInViewController: UIViewController, StoryboardBased {
    var viewModel: SignInViewModel!
    
    private let disposeBag: DisposeBag = .init()
    
    deinit {
        log.debug("deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        viewModel.output.signInSuccess
            .drive(onNext: { bool in
                log.debug("signInsuccess: \(bool)")
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        viewModel.input.signInButtonTapped.accept(())
    }
}

extension SignInViewController {
    static func create(with viewModel: SignInViewModel) -> SignInViewController {
        let vc: SignInViewController = .instantiate()
        vc.viewModel = viewModel
        return vc
    }
}
