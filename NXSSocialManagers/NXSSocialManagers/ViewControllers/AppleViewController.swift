//
//  AppleViewController.swift
//  NXSSocialManagers
//
//  Created by Naveen Sharma on 31/03/20.
//  Copyright © 2020 Naveen Sharma. All rights reserved.
//

import UIKit

class AppleViewController: UIViewController {

    // MARK: - IBOutlets ::
    @IBOutlet weak private var tblView: UITableView!

    // MARK: - Properties ::

    // MARK: - View Life Cycle Functions ::
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Apple"
        self.addAppleLogInButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    deinit {
    }

    // MARK: - Notifications Functions ::
    // MARK: - Internal Functions ::
    // MARK: - Private Functions ::
    private func addAppleLogInButton() {
        if #available(iOS 13.0, *) {
            NXSAppleSignInManager.shared.addSignInButton(onView: self.view) { (socialUserInfo, message, success) in
                if !success {
                    //Utility.showToast(message: message ?? "Apple Login Error")
                } else {
                    if let userInfo = socialUserInfo {
                        DispatchQueue.main.async {
                            //Call Login API Here
                        }
                    }
                }
            }
        }
    }

    // MARK: - Button Actions ::
    // MARK: - Selectors Actions ::
    // MARK: - UICollectionViewDelegate ::
    // MARK: - UICollectionViewDataSource ::
    // MARK: - UICollectionViewDelegateFlowLayout ::
    // MARK: - UITableViewDelegate ::
    // MARK: - UITableViewDataSource ::
    // MARK: - UIScrollViewDelegate ::
    // MARK: - UITextFieldDelegate ::
    // MARK: - UITextViewDelegate ::
    // MARK: - View Delegate ::
    // MARK: - ViewModel Delegate ::
}
