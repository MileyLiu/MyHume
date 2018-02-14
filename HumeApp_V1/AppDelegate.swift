//
//  AppDelegate.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 29/9/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift

import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI
import FirebaseTwitterAuthUI
import FirebasePhoneAuthUI
import GTMSessionFetcher



import UserNotifications
//signin
import GoogleSignIn


import FBSDKShareKit
import JSQMessagesViewController


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate,GIDSignInDelegate{
    
    var window: UIWindow?
     let gcmMessageIDKey = "gcm.message_id"
    var adLaunchView: AdLaunchView?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        LanguageHelper.shareInstance.initUserLanguage()
        
        UINavigationBar.appearance().tintColor = mainColor
       
//        IQKeyboardManager.sharedManager().enable = true
       
        GMSServices.provideAPIKey(APIKey)
        GMSPlacesClient.provideAPIKey(APIKey)
        
        
        if SQLiteManager.shareInstance().openDB() {
            print("开启数据库成功!")
        }
        
        FirebaseApp.configure()
        
//        sharing
        //facebook sharing
        if FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions){
            print("facebook init done")
            
        }
        //twiteer sharing
        Twitter.sharedInstance().start(withConsumerKey:"10fLqPlCvu1juCKzvuRlsgt6u", consumerSecret:"oXRIS7pIxLLyxcrhHVOsmA0iMdxprBATrxswt8NVxZu3zW53kz")
      
        //wechat sharing
        WXApi.registerApp("wx3f2ecefa538c7092")
        
        // google+ sharing
        var configureError: NSError?
        
        //        CGContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().clientID = "997130391655-mvr1enhaski5opuqpbr6o1iea3hi2ucc.apps.googleusercontent.com"
        
        GIDSignIn.sharedInstance().delegate = self
        
        print("gidsign")
        
//        */
        
        
      
         GTMSessionFetcher.setLoggingEnabled(true)
        
       
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        
        let authOptions :UNAuthorizationOptions = [.alert,.badge,. sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_,_ in })
        
        application.registerForRemoteNotifications()

        if let token = InstanceID.instanceID().token(){

            print("Token:\(token)")
        }
        
       
        window?.makeKeyAndVisible()
        
        adLaunchView = AdLaunchView(frame: UIScreen.main.bounds)
        adLaunchView?.delegate = self
        window?.addSubview(adLaunchView!)
        
      
        
        return true
    }
    
    
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        
        
        Twitter.sharedInstance().application(app, open: url, options: options)
        
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
        
//        return Twitter.sharedInstance().application(app, open: url, options: options)
    }
    
    
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
       
       
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let initViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "initView") as! ViewController
         let initViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "initView") as! ViewController
        self.window?.rootViewController? = initViewController
        return true
    }
    
   
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)
    
    // Print message ID.
        
    print("receving message")
    if let messageID = userInfo[gcmMessageIDKey] {
    print("Message ID: \(messageID)")
    }
    
    // Print full message.
    print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
         print("receving message") 
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    
        Auth.auth().setAPNSToken(deviceToken, type: .prod)
        print("deviceToken:\(deviceToken.base64EncodedString())")
    }
    
    func customLaunchImageView (){
        let launchImageView = UIImageView.init(frame: (self.window?.bounds)!)
        launchImageView.image = UIImage.init(named: "750")
        self.window?.addSubview(launchImageView)
        self.window?.bringSubview(toFront: launchImageView)
        
                let versionLabel = UILabel.init(frame: CGRect(x:100,y:260, width:100, height:30))
                versionLabel.backgroundColor = UIColor.cyan
                versionLabel.text = "Version"
                versionLabel.textAlignment = .center
                launchImageView.addSubview(versionLabel)
        
        
        let deadlineTime = DispatchTime.now() + 0.8
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            print("test")
            
            
            UIView.animate(withDuration: 1.2, animations: {
                launchImageView.alpha = 0.0
                launchImageView.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
            }, completion: { (finished) in
                launchImageView.removeFromSuperview()
            })
            
        }
        
        
    
    }
    


    //FOR SHARING facebook
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application,open: url as URL!,sourceApplication:sourceApplication,annotation: annotation)


    }
     
     
    
    

    
//    // For sharing twitter
//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//
////      var handel = FBSDKApplicationDelegate.sharedInstance().a
//
//
//        return Twitter.sharedInstance().application(app, open: url, options: options)
//        //            GIDSignIn.sharedInstance().handle(url,sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,annotation: options[UIApplicationOpenURLOptionsKey.annotation])
//    }
    
    // for sharing google plus
    func application(_ application: UIApplication,open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    
        
        let facebookSharing = FBSDKApplicationDelegate.sharedInstance().application(application,open: url as URL!,sourceApplication:sourceApplication,annotation: annotation)
        
        print("facebook sharing:\(facebookSharing)")
        
        
        let googleSharig = GIDSignIn.sharedInstance().handle(url,
                                                             sourceApplication: sourceApplication,
                                                             annotation: annotation)
         print("google sharing:\(googleSharig)")
        
        return facebookSharing && googleSharig
        
    }
    
    //for sharing google plus sign in
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
            // [START_EXCLUDE silent]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
            // [END_EXCLUDE]
            
            return
        }
//            else {
//            print("GOOGLE SIGN IN SUCESSFUL")
//            
            
            // Perform any operations on signed in user here.
//            let userId = user.userID                  // For client-side use only!
//            let idToken = user.authentication.idToken // Safe to send to the server
//            let fullName = user.profile.name
//            let givenName = user.profile.givenName
//            let familyName = user.profile.familyName
//            let email = user.profile.email
//            // [START_EXCLUDE]
//            NotificationCenter.default.post(
//                name: Notification.Name(rawValue: "ToggleAuthUINotification"),
//                object: nil,
//                userInfo: ["statusText": "Signed in user:\n\(fullName)"])
            // [END_EXCLUDE]
//        }
        
        guard let authentication = user.authentication else {return}
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        print("google sign in sucessful\(authentication.idToken),\(authentication.accessToken)\(user.profile.name)")
        
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // [START_EXCLUDE]
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil,
            userInfo: ["statusText": "User has disconnected."])
        // [END_EXCLUDE]
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        print("applicationWillResignActive")
        
//        a、暂停正在执行的任务；
//
//        b、禁止计时器；
//
//        c、减少OpenGL ES帧率；
//
//        d、若为游戏应暂停游戏；
        
     
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("applicationDidEnterBackground")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("applicationWillEnterForeground")
     
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "refreshHome"), object: nil)
        
        

      
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
        
        print("applicationDidBecomeActive")
        
        
      
        
        
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("applicationWillTerminate")
    }
    
    
    
}
extension AppDelegate: AdLaunchViewDelegate {
    func adLaunchView(launchView: AdLaunchView, bannerImageDidClick imageURL: String) {
        let urls = "http://www.humeplaster.com.au/"
        if let url: URL = URL(string: urls) {
            UIApplication.shared.openURL(url)
        }
        
    }
}
