//
//  SideMenuViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 31/10/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit
import SafariServices
import FBSDKShareKit
import FBSDKLoginKit
import GoogleSignIn
import Firebase

import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI
import FirebaseTwitterAuthUI
import FirebasePhoneAuthUI




class SideMenuViewController: UIViewController,SFSafariViewControllerDelegate,TWTRComposerViewControllerDelegate,FUIAuthDelegate{
    
    
    @IBOutlet weak var logoutButton: UIButton!
    let defaults = UserDefaults.standard
    let authUI = FUIAuth.defaultAuthUI()
    @IBOutlet weak var feedbackButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setButtonTitleAsChosenLanguage()
        
        if((defaults.object(forKey: "token")) != nil){
            
           
            
            loginButton.setTitle("\(LanguageHelper.getString(key: "WELCOME"))\(defaults.object(forKey: "displayName") ?? "")", for: .normal)
            
            logoutButton.isEnabled = true
        }
        else{
            loginButton.setTitle(LanguageHelper.getString(key: "LOGIN"), for: .normal)
            loginButton.isEnabled = true
            logoutButton.isEnabled = false
            
        }
        
        authUI?.delegate = self
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.setButtonTitleAsChosenLanguage()
        
    }
    // MARK: - View setting
    
    func setButtonTitleAsChosenLanguage(){
        self.feedbackButton.setTitle(LanguageHelper.getString(key: "FEEDBACK"), for: .normal)
        self.settingButton.setTitle(LanguageHelper.getString(key: "SETTING"), for: .normal)
        self.shareButton.setTitle(LanguageHelper.getString(key: "SHARE"), for: .normal)
        self.homeButton.setTitle(LanguageHelper.getString(key: "HOME"), for: .normal)
        self.logoutButton.setTitle(LanguageHelper.getString(key: "LOGOUT"), for: .normal)
    }
    
    // MARK: - Button
    
    @IBAction func shareClicked(_ sender: Any) {
        //TODO  CHANGE TO THE REAL LINK
        
        let url = URL(string:"http://www.humeplaster.com.au/")
        
        let actionSheetController: UIAlertController = UIAlertController(title: LanguageHelper.getString(key: "SOCIAL"), message: "", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: LanguageHelper.getString(key: "CANCEL"), style: .cancel) { _ in
            print("Cancel")
        }
        
        actionSheetController.addAction(cancelActionButton)
        let facebookActionButton = UIAlertAction(title: "Facebook", style: .default)
        { _ in
            print("facebookActionButton")
            
            
            if (FBSDKAccessToken.current() != nil)
            {
                
                print("facebook LOGIN")
            }
            else
            {
                
            }
            
            let content = FBSDKShareLinkContent.init()
            content.contentURL = url
            
            print("sharing content:\(content.contentURL)")
            
            FBSDKShareDialog.show(from:self, with: content, delegate: nil)
            
        }
        actionSheetController.addAction(facebookActionButton)
        
        let twitterActionButton = UIAlertAction(title: "Twitter", style: .default)
        { _ in
            print("twitterActionButton")
            
            
            if (Twitter.sharedInstance().sessionStore.hasLoggedInUsers()) {
                // App must have at least one logged-in user to compose a Tweet
                
                
            } else {
                // Log in, and then check again
                Twitter.sharedInstance().logIn { session, error in
                    if session != nil { // Log in succeeded
                        let composer = TWTRComposerViewController.emptyComposer()
                        print("Logging.....")
                        self.present(composer, animated: true, completion: nil)
                    } else {
                        let twitterAlert = UIAlertController(title: "No Twitter Accounts Available", message: "You must log in before presenting a composer.", preferredStyle: .alert)
                        twitterAlert.addAction(UIAlertAction(title: okString, style:UIAlertActionStyle.default))
                        self.present(twitterAlert,animated: false, completion: nil)
                    }
                }
            }
            
            if let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter) {
                
                //                vc.setInitialText(title)
                //                vc.add(image)
                vc.add(url)
                self.present(vc, animated: true)
            }
            else {
                
                print("not allow to tweet")
            }
            
            
        }
        
        
        actionSheetController.addAction(twitterActionButton)
        
        let wechatActionButton = UIAlertAction(title: "Wechat", style: .default)
        { _ in
            print("wechatActionButton")
            
            _ = String(describing: url)
            
        }
        
        actionSheetController.addAction(wechatActionButton)
        
        let gogglePlusActionButton = UIAlertAction(title: "google+", style: .default)
        { _ in
            print("gogglePlusActionButton")
            
            var urlComponents = URLComponents.init(string:"https://plus.google.com/share" )
            urlComponents?.queryItems = [URLQueryItem.init(name: "url", value: url?.absoluteString)]
            let newUrl = urlComponents?.url
            
            if SFSafariViewController.accessibilityActivate(){
                
                let controller = SFSafariViewController.init(url: newUrl!)
                controller.delegate = self
                self.present(controller, animated: true, completion: nil)
                
            }
            else{
                UIApplication.shared.openURL(newUrl!)
            }
            
        }
        
        actionSheetController.addAction(gogglePlusActionButton)
        
        //for ipad
        actionSheetController.popoverPresentationController?.sourceView = self.view
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(_ sender: Any) {
        //        FirebaseApp.configure()
        
        
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        
   
        //        let phoneProvider = FUIAuth.defaultAuthUI()?.providers.first as! FUIPhoneAuth
        //        phoneProvider.signIn(withPresenting: currentlyVisibleController, phoneNumber: nil)
        
        
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
            FUIFacebookAuth(),
            FUITwitterAuth(),
            FUIPhoneAuth(authUI:FUIAuth.defaultAuthUI()!),
            ]
        authUI?.providers = providers
        
        //        To get the sign-in method selector:
        
        let authViewController = authUI!.authViewController()
        
        self.present(authViewController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        
       
        
        
        let alert = UIAlertController(title:LanguageHelper.getString(key: "LOGOUT"), message: LanguageHelper.getString(key: "LOGOUT_MESSAGE"), preferredStyle: UIAlertControllerStyle.alert)
        
        
        alert.addAction(UIAlertAction(title: LanguageHelper.getString(key: "OK"), style: UIAlertActionStyle.default, handler: { action in
            
            self.defaults.set(nil,forKey: "token")
            self.loginButton.setTitle(LanguageHelper.getString(key: "LOGIN"), for: .normal)
            self.loginButton.isEnabled = true
            self.logoutButton.isEnabled = false
            
            do {
                try self.authUI?.signOut()
                
                
            } catch {
                return
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: cancelString, style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
       
        
            
        
        
        
        
        
        
        
        
        
   
    
    }
    
    
    
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if (error != nil){
            
            print("login error:\(error)")
        }
        else{
            
            let token = authUI.auth?.apnsToken?.base64EncodedString()
            
            print("login AUTH\(String(describing: authUI.auth?.apnsToken?.base64EncodedString()))")
            
            defaults.set(token, forKey: "token")
            defaults.set(user!.displayName, forKey: "displayName")
            
            self.loginButton.setTitle("\(LanguageHelper.getString(key: "WELCOME")),\(user!.displayName ?? "")", for: .normal)
            self.loginButton.isEnabled = false
            self.logoutButton.isEnabled = true
            
            
        }
    }
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
