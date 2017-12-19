//
//  NewHomeViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 19/12/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SDWebImage
import ObjectMapper
import SafariServices

class NewHomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SFSafariViewControllerDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
  
    
    
    var firstView: UIView?
    var secondView: UIView?
    var thirdView :UIView?
    
    
    var newsTableView: UITableView!
    var dataSource : NSMutableArray = NSMutableArray()
    var refreshControl: UIRefreshControl?
        var photoGallery = MLPhotoGallery.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-44))
//
    var images = ["morning","afternoon","evening"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            self.menuButton?.target = self.revealViewController()
            self.menuButton?.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let titleImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        
        titleImageView.image = UIImage(named:"titleLogo")
        titleImageView.contentMode = .scaleAspectFit
        
        self.navigationItem.titleView = titleImageView
        
   //first view setting
        
        
        firstView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-44))
    
        
        let bgImageView = UIImageView.init(frame:CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-44))
        
        bgImageView.image = UIImage(named:"evening")
        
        firstView?.addSubview(bgImageView)
        
        
        
        let weatherLabel = UILabel.init(frame: CGRect.init(x:UIScreen.main.bounds.width*0.6 , y: 10, width: UIScreen.main.bounds.width*0.3, height: 80))
        
        weatherLabel.text = "25ºC"
        weatherLabel.textColor = UIColor.white
        weatherLabel.font = UIFont.init(name: "Helvetica-Bold", size: 50)
        
        bgImageView.addSubview(weatherLabel)
        
        
        let timeLabel = UILabel.init(frame: CGRect.init(x:20 , y: UIScreen.main.bounds.height*0.2, width: UIScreen.main.bounds.width*0.7, height: UIScreen.main.bounds.height*0.2))
        
       
        timeLabel.text = "Good Evening"
        timeLabel.textColor = UIColor.white
        timeLabel.font = UIFont.init(name: "Helvetica-Bold", size: 50)
        timeLabel.textAlignment = .left
        
        timeLabel.lineBreakMode = .byClipping
        timeLabel.numberOfLines = 0
        bgImageView.addSubview(timeLabel)
        
        
        
        let weatherImageView = UIImageView.init(frame:CGRect.init(x: UIScreen.main.bounds.width*0.6, y: 100, width: 80, height: 80))
        
        weatherImageView.image = UIImage(named:"cloudy")
        
        bgImageView.addSubview(weatherImageView)
        
        
        //second view
        
        secondView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-44))
        
        
        let digitalImage = UIImageView.init(frame:CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-64))
        
        
        digitalImage.backgroundColor = UIColor.black
        
        digitalImage.contentMode = .scaleAspectFit
        
        digitalImage.image = UIImage(named:"goingdigital")
        
        secondView?.addSubview(digitalImage)
  
        
        
        //third view
        
        thirdView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-44))

       newsTableView = UITableView.init(frame:CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-100))
        
        let nib = UINib(nibName: "SliderNewsTableViewCell", bundle: nil)
        
        newsTableView.register(nib, forCellReuseIdentifier: "sliderNewsCell")
        
        
        
        newsTableView?.delegate = self
        newsTableView?.dataSource = self
       
        newsTableView?.rowHeight = UITableViewAutomaticDimension
        newsTableView?.estimatedRowHeight = 300
        
        loadData()
        createDropdownFresh()
        
        thirdView?.addSubview(self.newsTableView!)
        
        self.photoGallery.bindWithViews(array: [firstView!,secondView!,thirdView!], interval: 0.0, defaultImage: "morning" )
        

        self.view.addSubview(photoGallery)
        
        // Do any additional setup after loading the view.
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
        self.newsTableView?.addSubview(refreshControl!)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "sliderNewsCell") as! SliderNewsTableViewCell
        
//        let cell = UITableViewCell()
        let oneNews = self.dataSource[indexPath.row] as! News
        
      
        cell.titleLabel.text = oneNews.heading
        cell.descriptionLabel.text = oneNews.content
        cell.dateLabel.text = oneNews.date
//        cell.url = oneNews.linkUrl

        
        SDWebImageManager.shared().loadImage(with: URL(string:oneNews.imageUrl!) as URL!, options: SDWebImageOptions.continueInBackground, progress: { (receivedSize :Int, ExpectedSize :Int, url : URL) in
            
            } as? SDWebImageDownloaderProgressBlock, completed: { (image : UIImage?, any : Data?,error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                cell.newsImageView?.image = image

                
                
        })
//        cell.newsCellDelegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }


    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        
        let oneNews = self.dataSource[indexPath.row] as! News
        
        
        var web = URL(string: oneNews.linkUrl!)
        
        let controller = SFSafariViewController.init(url: web!)
        controller.delegate = self
        controller.modalTransitionStyle = .coverVertical
        controller.modalPresentationStyle = .formSheet
        self.present(controller, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func callus(_ sender: Any) {
        makePhoneCall()
    }
    
    func loadData() {
        SVProgressHUD.show()
        var url :String!=""
        
        //        let preferredLang = Bundle.main.preferredLocalizations.first! as NSString
        
        print("当前系统语言:\(preferredLang)")
        
        switch String(describing: preferredLang) {
        case "en-US", "en-CN":
            //en
            url = hostApi + "myHume-rest/news/get?language=en"
            
        case "zh-Hans-US","zh-Hans-CN","zh-Hant-CN","zh-TW","zh-HK","zh-Hans":
            //cn
            url = hostApi + "myHume-rest/news/get?language=cn"
            
        default:
            url = hostApi + "myHume-rest/news/get?language=en"
        }
        
        
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
                        print("news titles:\(String(describing: news?.heading))")
                        self.dataSource.add(news)
                        
                    }
                case .failure(let error):
                    print("Request Error:\(error)")
                    
                    SVProgressHUD.dismiss()
                    
                    let networkAlert = getSimpleAlert(titleString: alertString, messgaeLocizeString: "NETWORK_ERROR")
                    self.present(networkAlert, animated: true, completion: nil)
                    return
                    
                }
                self.newsTableView!.reloadData()
                SVProgressHUD.dismiss()
        }
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
