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


class SideMenuViewController: UIViewController,SFSafariViewControllerDelegate,TWTRComposerViewControllerDelegate{
    
    @IBOutlet weak var feedbackButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(LanguageHelper.getString(key: "FEEDBACK"))
        self.feedbackButton.setTitle(LanguageHelper.getString(key: "FEEDBACK"), for: .normal)
        self.settingButton.setTitle(LanguageHelper.getString(key: "SETTING"), for: .normal)
        self.shareButton.setTitle(LanguageHelper.getString(key: "SHARE"), for: .normal)
        self.homeButton.setTitle(LanguageHelper.getString(key: "HOME"), for: .normal)
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        self.feedbackButton.setTitle(LanguageHelper.getString(key: "FEEDBACK"), for: .normal)
        
        self.settingButton.setTitle(LanguageHelper.getString(key: "SETTING"), for: .normal)
        self.shareButton.setTitle(LanguageHelper.getString(key: "SHARE"), for: .normal)
        
        self.homeButton.setTitle(LanguageHelper.getString(key: "HOME"), for: .normal)
    }
    
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
            
            //            //LOGIN
            //            if let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
            //
            //                vc.setInitialText(title)
            //                vc.add(image)
            //                vc.add(URL(string: url.absoluteString))
            //                self.present(vc, animated: true)
            //            }
            //
            
            if (FBSDKAccessToken.current() != nil)
            {
                
                print("facebook LOGIN")
            }
            else
            {
                
                //                let facebookAlert = UIAlertController(title: "No Facebook Accounts Available", message: "You must log in before presenting a composer.", preferredStyle: .alert)
                //                facebookAlert.addAction(UIAlertAction(title: okString, style:UIAlertActionStyle.default))
                //                self.present(facebookAlert,animated: false, completion: nil)
                
                //                TODO LOGIN FACEBOOK
                //                               let loginView : FBSDKLoginButton = FBSDKLoginButton()
                //                                self.view.addSubview(loginView)
                //                                loginView.center = self.view.center
                //                                loginView.readPermissions = ["public_profile", "email", "user_friends"]
                //                                loginView.delegate = self as! FBSDKLoginButtonDelegate
            }
            
            let content = FBSDKShareLinkContent.init()
            content.contentURL = url
//            content.quote = title
            
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
            
            // Uncomment to automatically sign in the user.
            //GIDSignIn.sharedInstance().signInSilently()
            
            
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
