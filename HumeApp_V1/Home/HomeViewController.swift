//
//  HomeViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 14/11/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit
import SafariServices
import Alamofire
import SVProgressHUD
import ObjectMapper
import SDWebImage

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SFSafariViewControllerDelegate {
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var homeTableView: UITableView!
    var refreshControl: UIRefreshControl?
    
    var photoGallery = MLPhotoGallery.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.3 * getMultipler()))
    
    @IBOutlet weak var bannerView: UIView!
    var industryNews = [IndustryNews]()
    
    var humeDataSource : NSMutableArray = NSMutableArray()
    var picturesSource : [String]!
    
    var featureSource: NSMutableArray = NSMutableArray()
    var featureUrls: [String]?
    
    //    @IBOutlet weak var phoneButtonItem: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("deviceModel\(deviceModel)")
        
        //         SplashView.updateSplashData(imgUrl:"http://www.humeplaster.com.au/hume/wp-content/uploads/2017/11/Xmas-Notice-2017-Poster-20171120-1200x1697.jpg", actUrl: "http://jkyeo.com")
        
        //        self.phoneButtonItem.tintColor = mainColor
        
        if self.revealViewController() != nil {
            self.menuButton?.target = self.revealViewController()
            self.menuButton?.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        loadFeatures()
        
        
        
        let titleImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        
        titleImageView.image = UIImage(named:"titleLogo")
        titleImageView.contentMode = .scaleAspectFit
        
        print(self.navigationItem.titleView?.frame.size.width,self.navigationItem.titleView?.frame.size.width)
        
        self.navigationItem.titleView = titleImageView
        self.homeTableView.delegate = self
        self.homeTableView.dataSource = self
        
        self.homeTableView.separatorStyle = .none
        
        loadNews()
        
        industryNews = dataSource()
        
        createDropdownFresh()
        
    }
    
    @objc func refresh(sender:AnyObject) {
        
        self.humeDataSource = NSMutableArray()
        
        self.loadNews()
        self.loadFeatures()
        
        self.refreshControl?.endRefreshing()
        
    }
    func createDropdownFresh() -> Void {
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action:#selector(refresh), for: UIControlEvents.valueChanged)
        self.homeTableView.addSubview(refreshControl!)
        
    }
    
    
    
    func loadNews(){
        
        //todo: change real api
        SVProgressHUD.show()
        
        var images = [String]()
        var urls = [String]()
        
        let url = hostApi + "myHume-rest/news/get?language=en"
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
                        
                        images.append((news?.thumbnailSrc)!)
                        //                        self.urlSource.append((news?.linkUrl)!)
                        urls.append((news?.link)!)
                        
                        print("news url:\(String(describing: news?.link))")
                        
                        
                    }
                    self.photoGallery.bindWithServer(array: images, interval: 15.0, defaultImage: "banner")
                    self.photoGallery.setUrlLinks(links: urls)
                    
                    
                    
                case .failure(let error):
                    print("Request Error:\(error)")
                    
                    SVProgressHUD.dismiss()
                    
                    let networkAlert = getSimpleAlert(titleString: alertString, messgaeLocizeString: "NETWORK_ERROR")
                    self.present(networkAlert, animated: true, completion: nil)
                    return
                    
                }
                
                self.homeTableView.reloadData()
                SVProgressHUD.dismiss()
        }
        
        
    }
    
    func loadFeatures(){
        
        
        //todo: change real api
        //        SVProgressHUD.show()
        
        let url :String = hostApi + "myHume-rest/special/get"
        
        Alamofire.request(url)
            .validate()
            .responseJSON {response in
                switch response.result {
                case .success(let value):
                    
                    let resultArray = value as! NSArray
                    
                    if resultArray.count == 0 {
                        UIApplication.shared.endIgnoringInteractionEvents()
                        SVProgressHUD.dismiss()
                        return
                    }
                    
                    for index in 2..<5{
                        let special = Mapper<Special>().map(JSONObject: resultArray[index])
                        self.featureSource.add(special as Any)
                        
                        //                        self.featureUrls.append((special?.imageUrl)!)
                        self.featureUrls?.append((special?.imageUrl)!)
                        //                        self.featureUrls.add((special?.imageUrl)!)
                        
                        print("special:\(special?.imageUrl)")
                        
                    }
                case .failure(let error):
                    print("Request Error:\(error)")
                    
                    SVProgressHUD.dismiss()
                    
                    let networkAlert = getSimpleAlert(titleString: alertString, messgaeLocizeString: "NETWORK_ERROR")
                    self.present(networkAlert, animated: true, completion: nil)
                    return
                    
                }
                
                self.homeTableView.reloadData()
                //                self.productCollectionView?.reloadData()
                SVProgressHUD.dismiss()
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 || section == 1{
            return 1
        }
        else{
            return industryNews.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {        if indexPath.section == 0
//        && deviceModel == "iPhone"
        {
        
            return UIScreen.main.bounds.height*0.3 * getMultipler()
//        }
//        if indexPath.section == 0 && deviceModel == "iPad" {
//
//            return UIScreen.main.bounds.height*0.35
       }
        
        if indexPath.section == 1 {
            
            return UIScreen.main.bounds.height*0.2 * getMultipler()
        }
        else{
            
            return 120 * getMultipler()
        }
        
    }
    
    /*recover header dont remember change table view type
     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
     return 2.0
     }
     
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     
     let headerView = UIView(frame:CGRect(x:10,y: 0, width: tableView.frame.size.width,height:30))
     
     var imageView = UIImageView(frame:CGRect(x:12,y:3, width: 20,height:20))
     
     var label = UILabel(frame:CGRect(x:40,y: 0, width:tableView.frame.size.width-35 ,height:25))
     label.textColor = mainColor
     
     headerView.addSubview(imageView)
     headerView.addSubview(label)
     
     switch section {
     case 0:
     
     //            headerView.frame = CGRect(x:0,y:0,width: tableView.frame.size.width,height:tableView.frame.size.height)
     imageView.image = UIImage(named:"news")
     label.text = "Hume News"
     case 1:
     imageView.image = UIImage(named:"features")
     label.text = "Features"
     
     default:
     imageView.image = UIImage(named:"engineer")
     label.text = "Industry News"
     }
     
     return headerView
     }
     */
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 0
        }
        else {
            return 10
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "bannerCell") as! UITableViewCell
            cell.addSubview(photoGallery)
            return cell
            
        }
            
        else if indexPath.section == 1 && self.featureSource.count>0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "featureCell") as! SpecialTableViewCell
            
            cell.speicalCellDelegate = self
            cell.specialSource = self.featureSource
            
            let image1 = (self.featureSource[0] as! Special).imageUrl
            cell.featuresButton1.sd_setImage(with: URL(string:image1!), for: .normal, completed: nil)
            
            let image2 = (self.featureSource[1] as! Special).imageUrl
            cell.featuresButton2.sd_setImage(with: URL(string:image2!), for: .normal, completed: nil)
            
            let image3 = (self.featureSource[2] as! Special).imageUrl
            cell.featuresButton3.sd_setImage(with: URL(string:image3!), for: .normal, completed: nil)
        
            return cell
        }
        else {
            
            tableView.separatorStyle = .singleLine
            //            let titles = String["aaaaa","bbbbb","cccccc"]
            let cell = tableView.dequeueReusableCell(withIdentifier: "outNewsCell") as! IndustryNewsTableViewCell
            //            cell.textLabel?.text = "Outside news"
        
            cell.contentView.backgroundColor = .white
            cell.contentView.layer.cornerRadius = 10
            
            cell.imageView?.image = UIImage.init(named:industryNews[indexPath.row].img)
            //            cell.outTitle.text = titles[indexPath.row]
            cell.outTitle.text = industryNews[indexPath.row].title
            cell.outSourceLabel.text = industryNews[indexPath.row].source
            cell.url = industryNews[indexPath.row].url
            
            return cell
            
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //        SplashView.showSplashView(defaultImage: UIImage(named: "default_img"),
        //                                  tapSplashImageBlock: {(actionUrl) -> Void in
        //                                    print("splash image taped, actionUrl optional: \(actionUrl)")
        //        },
        
    }
    
    
    func dataSource()->[IndustryNews]{
        
        let news1 = IndustryNews()
        news1.title = "Landmark construction industry reforms to protect subbies"
        news1.img = "news1"
        news1.url = "https://www.sunshinecoastdaily.com.au/news/landmark-construction-industry-reforms-to-protect-/3250119/"
        news1.source = "Sunshine Coast Daily"
        
        
        let news2 = IndustryNews()
        news2.title = "Sydney women's shed encourages ladies to pick up tools, pursue trades"
        news2.img = "news2"
        news2.url = "http://www.abc.net.au/news/2017-11-05/womens-shed-helps-turn-ladies-into-tradies/9119208"
        news2.source = "ABC news"
        
        let news3 = IndustryNews()
        news3.title = "Trade surplus doubles to $1.7b while building approvals bounce "
        news3.img = "news3"
        news3.url = "http://www.abc.net.au/news/2017-11-02/trade-and-building-approvals-for-september-2017/9111164"
        news3.source = "ABC news"
        
        let newsArray = [news1,news2,news3]
        return newsArray
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
            
        case 2:
            var web = URL(string: industryNews[indexPath.row].url)
            
            let controller = SFSafariViewController.init(url: web!)
            controller.delegate = self
            controller.modalTransitionStyle = .coverVertical
            controller.modalPresentationStyle = .formSheet
            self.present(controller, animated: true, completion: nil)
        default:
            print("features")
            
        }
        
    }
    
    
    @IBAction func callUs(_ sender: Any) {
        makePhoneCall()
        
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

extension HomeViewController: SpecialViewCellDelegate{
    
    func openDetailPage(productId: Int) {
        
        print("special controller:\(productId)")
        
        var controller: ProductDetailViewController
        
        controller = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        
        
        controller.specialIndex = productId
        
        controller.specialDetail = self.featureSource[productId-1]
        
        present(controller, animated: false, completion: nil)
        //        present(controller, animated: false) {
        //            controller.specialIndex = productId
        //        }
        
    }
    
    
}
