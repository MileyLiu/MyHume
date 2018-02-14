//
//  NewsViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 29/9/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import ObjectMapper
import SDWebImage
//import FBSDKShareKit
//import FBSDKLoginKit
//import GoogleSignIn
import SafariServices


class NewsViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,
    UIActionSheetDelegate,
    SFSafariViewControllerDelegate
    //    GIDSignInUIDelegate,SFSafariViewControllerDelegate,TWTRComposerViewControllerDelegate
{
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var newsTableView: UITableView!
    var dataSource : NSMutableArray = NSMutableArray()
    var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if self.revealViewController() != nil {
            self.menuButton?.target = self.revealViewController()
            self.menuButton?.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.newsTableView.delegate = self
        self.newsTableView.dataSource = self
        
        self.navigationItem.title = LanguageHelper.getString(key: "COMPANY_NEWS")
        self.navigationController?.tabBarItem.title = LanguageHelper.getString(key: "NEWS")
//        self.newsTableView.rowHeight  = UITableViewAutomaticDimension
//        self.newsTableView.estimatedRowHeight = 300
       
        self.newsTableView.separatorStyle = .none
        //        GIDSignIn.sharedInstance().uiDelegate = self
        loadData()
        createDropdownFresh()
        
    }
    
    @objc func refresh(sender:AnyObject) {
        
        dataSource = NSMutableArray()
        
        self.loadData()
        
        self.refreshControl?.endRefreshing()
        
    }
    func createDropdownFresh() -> Void {
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action:#selector(refresh), for: UIControlEvents.valueChanged)
        self.newsTableView.addSubview(refreshControl!)
        
    }
    
    func loadData() {
        SVProgressHUD.show()
        var url :String!=""
        
        //        let preferredLang = Bundle.main.preferredLocalizations.first! as NSString
        
        url = "http://myhume.humeplaster.com.au/api/news?type=list"
        
        
        Alamofire.request(url)
            .validate()
            .responseJSON {response in
                switch response.result {
                case .success(let value):
                    
                    let resultArray = value as! NSArray
                    
                    if resultArray.count == 0 {
                        
                        SVProgressHUD.dismiss()
                        
                        return
                    }
                    for index in 0..<resultArray.count{
                        
                        let news = Mapper<News>().map(JSONObject: resultArray[index])
                        print("news titles:\(String(describing: news?.title))")
                        self.dataSource.add(news)
                        
                    }
                case .failure(let error):
                    print("Request Error:\(error)")
                    
                    SVProgressHUD.dismiss()
                    
                    let networkAlert = getSimpleAlert(titleString: alertString, messgaeLocizeString: "NETWORK_ERROR")
                    self.present(networkAlert, animated: true, completion: nil)
                    return
                    
                }
                self.newsTableView.reloadData()
                SVProgressHUD.dismiss()
        }
    }
    
    
    @IBAction func callUs(_ sender: Any) {
        makePhoneCall()
        
    }
    
    
    
    @IBAction func prioritySupport(_ sender: Any) {
        var controller: PriorityViewController
        
        controller = self.storyboard?.instantiateViewController(withIdentifier: "PriorityViewController") as! PriorityViewController
        
        present(controller, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }else{
            return self.dataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            print("doggy")
        }
        else{
            let oneNews = self.dataSource[indexPath.row] as! News
            let webUrl =  oneNews.link
            
            let web = URL(string:webUrl!)
            
            let controller = SFSafariViewController.init(url: web!)
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
            
        }
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bannerCell")
            
            return cell!
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! NewsTableViewCell
            let oneNews = self.dataSource[indexPath.row] as! News
            
            let userLang = UserDefaults.standard.value(forKey: "UserLanguage") as! String
            
            print("当前用户语言:\(userLang)")
            
            var lang: String!=""
            
            switch String(describing: userLang) {
            case "en-US", "en-CN":
                //en
                cell.titleLabel.text = oneNews.title
                cell.descriptionLabel.text = oneNews.content
            case "zh-Hans-US","zh-Hans-CN","zh-Hant-CN","zh-TW","zh-HK","zh-Hans":
                //cn
                cell.titleLabel.text = oneNews.titleCn
                cell.descriptionLabel.text = oneNews.contentCn
                
            default:
                cell.titleLabel.text = oneNews.title
                cell.descriptionLabel.text = oneNews.content
            }
            
            cell.dateLabel.text = oneNews.date
            cell.url = oneNews.link
            
            
            SDWebImageManager.shared().loadImage(with: URL(string:oneNews.thumbnailSrc!) as URL!, options: SDWebImageOptions.continueInBackground, progress: { (receivedSize :Int, ExpectedSize :Int, url : URL) in
                
                } as? SDWebImageDownloaderProgressBlock, completed: { (image : UIImage?, any : Data?,error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                    
                    cell.picImageView.image = image
                    
                    
            })
            cell.newsCellDelegate = self
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 210
        }else{

            return (UIScreen.main.bounds.height-128-210)/2
        }
    }
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        if segue.identifier == "newsDetail" {
        //
        //            let nextViewController = segue.destination as! NewsDetailViewController
        //
        //            nextViewController.testURL = sender as! String
        //        }
        
    }
    
}


extension NewsViewController: NewsCellDelegate{
    func shareToSocialMedia(title: String, url: URL, image:UIImage) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: LanguageHelper.getString(key: "SOCIAL"), message: "", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: LanguageHelper.getString(key: "CANCEL"), style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        /*
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
         content.quote = title
         
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
         
         vc.setInitialText(title)
         vc.add(image)
         vc.add(URL(string: url.absoluteString))
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
         urlComponents?.queryItems = [URLQueryItem.init(name: "url", value: url.absoluteString)]
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
         
         self.present(actionSheetController, animated: true, completion: nil)
         
         */
    }
    
    
    
    
    
    
}
