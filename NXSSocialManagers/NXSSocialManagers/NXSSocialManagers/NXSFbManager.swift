//
//  FbManager.swift
//  NXSSocialManagers
//
//  Created by Naveen Sharma on 01/02/20.
//  Copyright © 2020 Naveen Sharma. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class NXSFbManager: NSObject {

    // MARK: - Properties ::
    internal static let shared: NXSFbManager = {
        return NXSFbManager()
    }()

    // MARK: - Functions ::
    func initilize(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    {
        print("NXSFbManager :: Initilize")
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool
    {
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }

    func login(viewController: UIViewController, completionClosure: @escaping (_ socialUserInfo: SocialUserInfo?, _ message: String?, _ success: Bool) -> ())
    {
        print("NXSFbManager :: Login Initiated")
        if let accessToken = AccessToken.current
        {
            print("NXSFbManager :: Facebook Access Token :: \(accessToken)")
            self.getUserInfo() { (socialUserInfo, message, success) in
                completionClosure(socialUserInfo, message, success)
            }
        }
        else
        {
            LoginManager().logIn(permissions: ["public_profile", "email"], from: viewController) { [weak self] (result, error) in
                guard let strongSelf = self else { return }
                if error != nil
                {
                    print("NXSFbManager :: Facebook Login Error 1 :: \(error.debugDescription)")
                    completionClosure(nil, "Facebook Login Error", false)
                }
                else if result?.isCancelled ?? false
                {
                    completionClosure(nil, "Facebook Login Cancelled", false)
                }
                else
                {
                    if let accessToken = AccessToken.current
                    {
                        print("NXSFbManager :: Facebook Access Token :: \(accessToken)")
                        strongSelf.getUserInfo() { (socialUserInfo, message, success) in
                            completionClosure(socialUserInfo, message, success)
                        }
                    }
                    else
                    {
                        print("NXSFbManager :: Facebook Login Error 2")
                        completionClosure(nil, "Facebook Login Error", false)
                    }
                }
            }
        }
    }

    private func getUserInfo(completionClosure: @escaping (_ socialUserInfo: SocialUserInfo?, _ message: String?, _ success: Bool) -> ())
    {
        print("NXSFbManager :: Getting User Information")

        //AppLoader.startLoaderToAnimating()
        //Graph Path = "me/friends" and "me"
        GraphRequest.init(graphPath: "me", parameters: ["fields":"id, name, email, picture.width(200).height(200)"])
          .start { (connection, result, error) in
                //AppLoader.stopLoaderToAnimating()
                //guard let strongSelf = self else {return}
                if error != nil
                {
                    print("NXSFbManager :: Facebook Login Error :: \(error.debugDescription)")
                    completionClosure(nil, "Facebook Login Error", false)
                }
                else
                {
                    guard let user = result as? [String: Any] else { return }
                    let name = (user["name"] as? String) ?? ""
                    let email = (user["email"] as? String) ?? ""
                    let userId = (user["id"] as? String) ?? ""
                    var imageURL: String = ""
                    if let profilePictureObj = user["picture"] as? [String: Any],
                        let data = profilePictureObj["data"] as? [String: Any],
                        let pictureUrlString  = data["url"] as? String,
                        let pictureUrl = NSURL(string: pictureUrlString)
                    {
                        imageURL = pictureUrl.absoluteString ?? ""
                    }

                    let socialUserInfo = SocialUserInfo(type: SocialLoginType.facebook, userId: userId, name: name, email: email, profilePic: imageURL)

                    print("NXSFbManager :: User Info = UserId: \(userId), UserName: \(name), UserEmail: \(email), UserProfilePic: \(imageURL)")

                    completionClosure(socialUserInfo, "Faceboo Login Success", true)
                }
           }
    }

    func isUserLogin() -> Bool {
        if AccessToken.current != nil
        {
            return true
        }
        else
        {
            return false
        }
    }

    func logout() {
        LoginManager().logOut()
    }
}
