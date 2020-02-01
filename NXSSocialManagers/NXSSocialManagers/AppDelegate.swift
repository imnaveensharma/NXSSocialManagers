//
//  AppDelegate.swift
//  NXSSocialManagers
//
//  Created by Naveen Sharma on 01/02/20.
//  Copyright © 2020 Naveen Sharma. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = UIColor.white
        self.window!.makeKeyAndVisible()

        print("AppDelegate :: Screen Height -> \(UIScreen.main.bounds.size.height)")
        print("AppDelegate :: Screen Width -> \(UIScreen.main.bounds.size.width)")

        NXSFbManager.shared.initilize(application: application, launchOptions: launchOptions)
        NXSGoogleManager.shared.initilize()
        self.setRootViewC()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if NXSFbManager.shared.application(app, open: url, options: options) || NXSGoogleManager.shared.application(app, open: url, options: options) {
            return true
        }
        return false
    }

    // MARK: - Internal Functions ::

    // MARK: - Private Functions ::
    private func setRootViewC() {
        self.setMainViewCAsRoot()
    }

    private func setMainViewCAsRoot() {
        if let objViewC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as? MainViewController {
            let objNavigationC = UINavigationController.init(rootViewController: objViewC)
            self.window?.rootViewController = objNavigationC
        }
    }
}

