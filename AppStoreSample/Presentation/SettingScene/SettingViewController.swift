//
//  SettingViewController.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/17.
//

import UIKit
import Reusable

final class SettingViewController: UIViewController, StoryboardBased {
    
    let viewModel: SettingViewModel = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signOutTapped(_ sender: UIButton) {
        viewModel.input.signOutTapped.accept(())
    }
}
