//
//  PopupSMViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 12/2/18.
//  Copyright © 2018 MileyLiu. All rights reserved.
//

import UIKit
import SafariServices
import FBSDKShareKit
import FBSDKLoginKit
import GoogleSignIn

class PopupSMViewController: UIViewController,SFSafariViewControllerDelegate,TWTRComposerViewControllerDelegate {

    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var cancalButton: UIButton!
    let url = URL(string:"http://www.humeplaster.com.au/")
    override func viewDidLoad() {
        super.viewDidLoad()
 self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.popView.layer.cornerRadius = 10
        self.cancalButton.layer.cornerRadius = 10
        self.showAnimation()
        // Do any additional setup after loading the view.
    }
    @IBAction func close(_ sender: Any) {
//        self.removeAnimation()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func shareToFB(_ sender: Any) {
        
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
    
    @IBAction func shareToTwitter(_ sender: Any) {
        
        
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
    
    @IBAction func shareToGoogle(_ sender: Any) {
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
    @IBAction func shareToWechat(_ sender: Any) {
    }
    
    func showAnimation(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.1, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
        
    }
    func removeAnimation(){
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
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
