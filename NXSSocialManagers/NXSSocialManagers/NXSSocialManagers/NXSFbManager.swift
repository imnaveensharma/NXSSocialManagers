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
import FBSDKShareKit

//Dashboard: https://developers.facebook.com/apps
//Implementation: https://developers.facebook.com/docs/ios/getting-started/

class NXSFbManager: NSObject, SharingDelegate {

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

    func openShareDialogWithContentURL(url: URL?, message: String?, fromViewController viewController: UIViewController)
    {
        let content: ShareLinkContent = ShareLinkContent()
        if url != nil { content.contentURL = url! } //URL(string: "https://developers.facebook.com")!
        content.quote = message ?? ""
        //content.hashtag = Hashtag("#MadeWithHackbook")

        let shareDialog: ShareDialog = ShareDialog()
        shareDialog.shareContent = content

        if shareDialog.canShow {
            let _ = ShareDialog(fromViewController: viewController, content: content, delegate: self).show()
        }
    }

    func openShareDialogWithImage(image: UIImage, fromViewController viewController: UIViewController)
    {
        let photo: SharePhoto = SharePhoto()
        photo.image = image
        photo.isUserGenerated = true

        let content: SharePhotoContent = SharePhotoContent()
        content.photos = [photo]

        let shareDialog: ShareDialog = ShareDialog()
        shareDialog.shareContent = content

        if shareDialog.canShow {
            let _ = ShareDialog(fromViewController: viewController, content: content, delegate: nil)
        }
    }

    func shareImage(image: UIImage)
    {
        let photo: SharePhoto = SharePhoto()
        photo.image = image
        photo.isUserGenerated = true

        let content: SharePhotoContent = SharePhotoContent()
        content.photos = [photo]
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

                    completionClosure(socialUserInfo, "Facebook Login Success", true)
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

    // MARK: - SharingDelegate ::
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        print("NXSFbManager :: Sharing Done")
    }

    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        print("NXSFbManager :: Sharing Fail with Error :: \(error)")
    }

    func sharerDidCancel(_ sharer: Sharing) {
        print("NXSFbManager :: Sharing Cancel")
    }
}
