//
//  AppDelegate.swift
//  CIN
//
//  Created by 유호준 on 2021/08/19.
//

import UIKit
import RIBs
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let launchRouter = RootBuilder(dependency: AppComponent()).build()
        self.launchRouter = launchRouter
        
        launchRouter.launchFromWindow(window)
        return true
    }
    //MARK: - Private
    private var launchRouter: LaunchRouting?
}

