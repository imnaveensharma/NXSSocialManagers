//
//  GoogleManager.swift
//  NXSSocialManagers
//
//  Created by Naveen Sharma on 01/02/20.
//  Copyright © 2020 Naveen Sharma. All rights reserved.
//

import UIKit
import GoogleSignIn

class NXSGoogleManager: NSObject, GIDSignInDelegate {

    private var googleLoginResult:((_ socialUserInfo: SocialUserInfo?, _ message: String?, _ success: Bool)->())?

    // MARK: - Properties ::
    internal static let shared: NXSGoogleManager = {
        return NXSGoogleManager()
    }()

    // MARK: - Functions ::
    func initilize()
    {
        print("NXSGoogleManager :: Initilize")
        GIDSignIn.sharedInstance().clientID = "Provide Your Client Id Here"
        GIDSignIn.sharedInstance().delegate = self
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool
    {
        return GIDSignIn.sharedInstance().handle(url)
    }

    func login(viewController: UIViewController, completionClosure: @escaping (_ socialUserInfo: SocialUserInfo?, _ message: String?, _ success: Bool) -> ())
    {
        print("NXSGoogleManager :: Google Login Initiated")
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = viewController
        //GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        GIDSignIn.sharedInstance().signIn()
        self.googleLoginResult = { socialUserInfo, message, success in
            completionClosure(socialUserInfo, message, success)
        }
    }

    func logout() {
        GIDSignIn.sharedInstance().signOut()
    }

    // MARK: - GIDSignInDelegate ::
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?)
    {
        if let error = error
        {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue ||
               (error as NSError).code == GIDSignInErrorCode.canceled.rawValue ||
               (error as NSError).code == GIDSignInErrorCode.unknown.rawValue
            {
                print("NXSGoogleManager :: Google Login Error 1 :: \(error.localizedDescription)")
                self.googleLoginResult?(nil, "Google Login Error", false)
            }
            else
            {
                print("NXSGoogleManager :: Google Login Error 2 :: \(error.localizedDescription)")
                self.googleLoginResult?(nil, "Facebook Login Error", false)
            }
        }
        else
        {
            guard let user = user else { return }
            let name = user.profile.name ?? ""
            let email = user.profile.email ?? ""
            let userId = user.userID ?? ""
            var imageURL: String = ""
            if let profilePic = user.profile.imageURL(withDimension: 200) {
                imageURL = profilePic.absoluteString
            }

            let socialUserInfo = SocialUserInfo(type: SocialLoginType.facebook, userId: userId, name: name, email: email, profilePic: imageURL)

            print("NXSGoogleManager :: User Info = UserId: \(userId), UserName: \(name), UserEmail: \(email), UserProfilePic: \(imageURL)")

            self.googleLoginResult?(socialUserInfo, "Google Login Success", true)
        }
    }
}
