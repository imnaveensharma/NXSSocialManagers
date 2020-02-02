# NXSSocialManagers
Sample App for Social Managers (Facebook Login, Google Login) in Swift Language


## Getting Started
- Clone or Download this repo to your local machine using https://github.com/imnaveensharma/NXSSocialManagers.git

- Now drag & drop NXSSocialManagers folder to your project.


### Prerequisites
- Create a App on Facebook developer portal for Facebook and follow Quick guide to setup info.plist.
   - https://developers.facebook.com/apps
   - https://github.com/facebook/facebook-ios-sdk
   - https://developers.facebook.com/docs/
   - https://developers.facebook.com/docs/ios/getting-started/
   - https://developers.facebook.com/docs/swift

- Create a project on Google Cloud Platform console for Google. Copy "Client Id" and Add URL Scheme as described in documents.
   - https://console.cloud.google.com/home/dashboard
   - https://developers.google.com/identity/sign-in/ios/sign-in
   - https://developers.google.com/identity/sign-in/ios/start-integrating


### Facebook

Add the following to your Podfile and run pod install.
```
pod 'FBSDKLoginKit'
pod 'FBSDKCoreKit'
```

```
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        NXSFbManager.shared.initilize(application: application, launchOptions: launchOptions)
        return true
}
```

```
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if NXSFbManager.shared.application(app, open: url, options: options) {
            return true
        }
        return false
}
```

```
private func facebookLogin() {
        NXSFbManager.shared.login(viewController: self) { (socialUserInfo, message, success) in
            if !success {
                //Show Toast or Alert
                print(message ?? "Facebook Login Error")
            } else {
                if let userInfo = socialUserInfo {
                    print("User Info -> Id :: \(userInfo.userId)")
                }
            }
        }
}
```

```
private func facebookLogout() {
        NXSFbManager.shared.logout()
}
```


### Google

Add the following to your Podfile and run pod install.
```
pod 'GoogleSignIn'
```

```
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        NXSGoogleManager.shared.initilize()
        return true
}
```

```
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if NXSGoogleManager.shared.application(app, open: url, options: options) {
            return true
        }
        return false
}
```

```
private func googleLogin() {
        NXSGoogleManager.shared.login(viewController: self) { (socialUserInfo, message, success) in
            if !success {
                //Show Toast or Alert
                print(message ?? "Google Login Error")
            } else {
                if let userInfo = socialUserInfo {
                    print("User Info -> Id :: \(userInfo.userId)")
                }
            }
        }
}
```

```
private func googleLogout() {
        NXSGoogleManager.shared.logout()
}
```
