//
//  GoogleViewController.swift
//  NXSSocialManagers
//
//  Created by Naveen Sharma on 01/02/20.
//  Copyright © 2020 Naveen Sharma. All rights reserved.
//

import UIKit

class GoogleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - IBOutlets ::
    @IBOutlet weak private var tblView: UITableView!

    // MARK: - Properties ::
    private var arrayContent = [[String: Any]]()

    // MARK: - View Life Cycle Functions ::
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Google"
        
        self.updateAndReloadTable()
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
    private func updateAndReloadTable() {
        self.arrayContent.append(["title": "Login"])
        self.tblView.reloadData()
    }

    private func login() {
        NXSGoogleManager.shared.login(viewController: self) { (socialUserInfo, message, success) in
            if !success {
                //Show Toast or Alert
                print(message ?? "Google Login Error")
            } else {
                if let userInfo = socialUserInfo {
                    print("User Info -> Id :: \(userInfo.userId)")

                    self.arrayContent.removeAll()
                    self.updateAndReloadTable()
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
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 { //Login
            self.login()
        }
    }

    // MARK: - UITableViewDataSource ::
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayContent.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDefault: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cellDefault.selectionStyle = .none
        cellDefault.textLabel?.text = self.arrayContent[indexPath.row]["title"] as? String
        cellDefault.imageView?.image = nil
        return cellDefault
    }

    // MARK: - UIScrollViewDelegate ::
    // MARK: - UITextFieldDelegate ::
    // MARK: - UITextViewDelegate ::
    // MARK: - View Delegate ::
    // MARK: - ViewModel Delegate ::
}
