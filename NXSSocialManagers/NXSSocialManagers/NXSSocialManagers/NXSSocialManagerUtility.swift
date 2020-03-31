//
//  NXSSocialManagerUtility.swift
//  NXSSocialManagers
//
//  Created by Naveen Sharma on 31/03/20.
//  Copyright © 2020 Naveen Sharma. All rights reserved.
//

import UIKit

class NXSSocialManagerUtility: NSObject {

    // MARK: - UIViewController ::
    class func rootViewController() -> UIViewController? {
        return (UIApplication.shared.keyWindow?.rootViewController)
    }

    class func topMostViewController(rootViewController: UIViewController?) -> UIViewController? {
        if rootViewController == nil {
            return nil
        }

        if let navigationController = rootViewController as? UINavigationController {
            return topMostViewController(rootViewController: navigationController.visibleViewController!)
        }

        if let tabBarController = rootViewController as? UITabBarController {
            if let selectedTabBarController = tabBarController.selectedViewController {
                return topMostViewController(rootViewController: selectedTabBarController)
            }
        }

        if let presentedViewController = rootViewController!.presentedViewController {
            return topMostViewController(rootViewController: presentedViewController)
        }

        return rootViewController
    }

    // MARK: - UIAlertController ::
    class func showOkAlert(title: String, message: String) {
        if let topViewController = NXSSocialManagerUtility.topMostViewController(rootViewController: NXSSocialManagerUtility.rootViewController()) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            topViewController.present(alertController, animated: true, completion: nil)
        } else {
            print("NXSSocialManagerUtility :: showOkAlert :: Unable to get Top Most View Controller")
        }
    }

}
