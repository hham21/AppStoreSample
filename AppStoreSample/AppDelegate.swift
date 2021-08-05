//
//  AppDelegate.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/02.
//

import UIKit
import SwiftyBeaver

let log = SwiftyBeaver.self

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let console = ConsoleDestination()
        log.addDestination(console)

        let window = UIWindow(frame: UIScreen.main.bounds)
        Application.shared.startApp(with: window)
        self.window = window
        return true
    }
}

