//
//  NXSAppleSignInManager.swift
//  NXSSocialManagers
//
//  Created by Naveen Sharma on 31/03/20.
//  Copyright © 2020 Naveen Sharma. All rights reserved.
//

import UIKit
import Foundation
import AuthenticationServices

class NXSAppleSignInManager: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

    private var appleSignInResult:((_ socialUserInfo: SocialUserInfo?, _ message: String?, _ success: Bool)->())?

    // MARK: - Properties ::
    internal static let shared: NXSAppleSignInManager = {
        return NXSAppleSignInManager()
    }()

    // MARK: - Functions ::
    @available(iOS 13.0, *)
    func addSignInButton(onView view: UIView, completionClosure: @escaping (_ socialUserInfo: SocialUserInfo?, _ message: String?, _ success: Bool) -> ()) {

        let authorizationButton = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
        authorizationButton.addTarget(self, action: #selector(tapBtnAppleLogin(sender:)), for: .touchUpInside)
        //authorizationButton.frame = frame
        view.addSubview(authorizationButton)

        authorizationButton.layer.cornerRadius = 5.0
        authorizationButton.layer.borderWidth = 1.0
        authorizationButton.layer.borderColor = UIColor.lightGray.cgColor
        authorizationButton.layer.masksToBounds = true
        authorizationButton.clipsToBounds = true

        // Setup Layout Constraints to be in the center of the screen
        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authorizationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authorizationButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            authorizationButton.widthAnchor.constraint(equalToConstant: 228),
            authorizationButton.heightAnchor.constraint(equalToConstant: 49)
            ])

        self.appleSignInResult = { socialUserInfo, message, success in
            completionClosure(socialUserInfo, message, success)
        }
    }

    @available(iOS 13.0, *)
    private func performExistingAccountSetupFlows() {
        let requests = [ASAuthorizationAppleIDProvider().createRequest(), ASAuthorizationPasswordProvider().createRequest()]

        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    @available(iOS 13.0, *)
    func getCredentialState(userID: String) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: userID) { credentialState, _ in
            switch credentialState {
            case .authorized:
                // The Apple ID credential is valid.
                break
            case .revoked:
                // The Apple ID credential is revoked.
                break
            case .notFound:
                // No credential was found, so show the sign-in UI.
                break
            default:
                break
            }
        }
    }


    @available(iOS 13.0, *)
    @objc private func tapBtnAppleLogin(sender: ASAuthorizationAppleIDButton) {

        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    // MARK: - ASAuthorizationControllerDelegate ::
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("NXSAppleSignInManager :: AppleID Credential Failed With Error: \(error.localizedDescription)")
        self.appleSignInResult?(nil, "Apple Login Error", false)
    }

    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {

            let dataBlank = "".data(using: .utf8)
            if appleIDCredential.email != nil {
                let userIdentifier = appleIDCredential.user
                let userFirstName = appleIDCredential.fullName?.givenName ?? ""
                let userLastName = appleIDCredential.fullName?.familyName ?? ""
                let userFullName = userFirstName + userLastName
                let userEmail = appleIDCredential.email ?? ""

                //KeychainManager.save(key: "Id", data: userIdentifier.data(using: .utf8) ?? dataBlank!)
                _ = NXSKeychainManager.save(key: "UserFirstName", data: userFirstName.data(using: .utf8) ?? dataBlank!)
                _ = NXSKeychainManager.save(key: "UserLastName", data: userLastName.data(using: .utf8) ?? dataBlank!)
                _ = NXSKeychainManager.save(key: "UserEmail", data: userEmail.data(using: .utf8) ?? dataBlank!)

                let socialUserInfo = SocialUserInfo(type: SocialLoginType.apple, userId: userIdentifier, name: userFullName, email: userEmail, profilePic: "")

                print("NXSAppleSignInManager :: User Info = UserId: \(userIdentifier), UserName: \(userFullName), UserEmail: \(userEmail)")

                self.appleSignInResult?(socialUserInfo, "Apple Login Success", true)
            }

        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {

            // Sign in using an existing iCloud Keychain credential.
            //let username = passwordCredential.user
            //let password = passwordCredential.password

            //Navigate to other view controller
        }
    }

    // MARK: - ASAuthorizationControllerPresentationContextProviding ::
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.window!
    }
}
