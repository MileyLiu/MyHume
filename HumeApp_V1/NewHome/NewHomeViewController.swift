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
//import SafariServices
import GoogleMaps
import GooglePlaces
import SwiftGifOrigin


class NewHomeViewController: UIViewController,GMSMapViewDelegate
    ,UITableViewDelegate,UITableViewDataSource,SWRevealViewControllerDelegate
    //,SFSafariViewControllerDelegate
    
    
{
    
    var sidebarMenuOpen :ObjCBool = false
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var forecastWeatherArray :NSMutableArray = NSMutableArray()
    var accuWeatherList :[AccuWeather] = []
   
    //weatherView
    var weatherView = WeatherView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: screenHeight-44))
    
    //scondview init
    var secondView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight-44))
    
    //fullscreenNews
    
    var fullScreenNews = FullScreenNewsView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: screenHeight-44))
  
    var newsTableView: UITableView!
    var dataSource : NSMutableArray = NSMutableArray()
    
    var blankView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight-44))
    var refreshControl: UIRefreshControl?
    var photoGallery = MLPhotoGallery.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight-44))
    var news :[News] = []
    
    
    //location init
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var likelyPlaces: [GMSPlace] = []
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()
        
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if self.revealViewController() != nil {
            self.menuButton?.target = self.revealViewController()
      
            self.menuButton?.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
//
            self.revealViewController().panGestureRecognizer()
            self.revealViewController().tapGestureRecognizer()
//
//            self.revealViewController().
            
//             self.revealViewController().delegate = self
            
        
        }
        
       
        
        
        self.navigationController?.tabBarItem.title = LanguageHelper.getString(key: "HOME")
        let titleImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        
        titleImageView.image = UIImage(named:"titleLogo")
        titleImageView.contentMode = .scaleAspectFit
        
        self.navigationItem.titleView = titleImageView
        
        if isFirstRunApp(){
            
            popupLogin()
        }
        
        //get current loaction
        locationManager.delegate = self
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        
        placesClient = GMSPlacesClient.shared()
        
        loadData()
        setupWeatherView()
        //        setUpSecondView()
        //        setupThirdiew()
        
        //refresh firstView notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshFirstView), name: Notification.Name(rawValue: "refreshHome"), object: nil)
        
        
        self.photoGallery.bindWithViews(array: [weatherView,secondView,fullScreenNews], interval: 0.0)
        
        
      
        
        
        self.view.addSubview(photoGallery)
        
        self.photoGallery.isHidden = false
        self.blankView.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    func popupLogin(){
        
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let startViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "startView")
        
        self.present(startViewController, animated: true, completion: nil)
        
    }
    
    
    @objc func refreshFirstView(){
        
        print("refreshFirstView........")
        setupWeatherView()
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()
     
        
    }

    
    
//    func revealController(revealController: SWRevealViewController!,  willMoveToPosition position: FrontViewPosition){
//        if(position == FrontViewPosition.left) {
//            self.view.isUserInteractionEnabled = true
//            sidebarMenuOpen = false
//            print("FrontViewPosition.left1\(sidebarMenuOpen))")
//        } else {
//            self.view.isUserInteractionEnabled = false
//            print("FrontViewPosition.left2\(sidebarMenuOpen))")
//            sidebarMenuOpen = true
//        }
//    }
//
//    func revealController(revealController: SWRevealViewController!,  didMoveToPosition position: FrontViewPosition){
//        if(position == FrontViewPosition.left) {
//            self.view.isUserInteractionEnabled = true
//            sidebarMenuOpen = false
//               print("FrontViewPosition.left1\(sidebarMenuOpen))")
//        } else {
//            self.view.isUserInteractionEnabled = false
//            sidebarMenuOpen = true
//               print("FrontViewPosition.left1\(sidebarMenuOpen))")
//        }
//    }
//
//
//
//    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
//        if(sidebarMenuOpen){
//            return nil
//        } else {
//            return indexPath
//        }
//    }
    
    
    func setUpSecondView(newsArray:[News]){
        
        let othersHeight = (self.navigationController?.navigationBar.frame.height)! + (self.tabBarController?.tabBar.frame.height)! + 20.0
        let digitalImage = UIImageView.init(frame:CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight-othersHeight))
        
        digitalImage.backgroundColor = UIColor.black
        //        digitalImage.contentMode = .scaleAspectFill
        digitalImage.contentMode = .scaleToFill
        digitalImage.image = UIImage(named:"goingdigital")
        
        print("secondView Width:\(secondView.frame.width)")
        
        secondView.addSubview(digitalImage)
        
    }
    func setupWeatherView(){
        
        let timeBucket = getTimeBucket()
    
        weatherView.bindWithData(bgImageName: "", timeBucket: timeBucket, temperature: "N/A",weatherIamge: "ic_cloudy")
        
        weatherView.forecastTableView.delegate = self
        weatherView.forecastTableView.dataSource = self
        
        weatherView.forecastTableView.register(UINib.init(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "weatherForecastCell")
        
        
        
    }
    
    func setUpFullScreenNews(newArrary:[News]){
        
        
        let userLang = UserDefaults.standard.value(forKey: "UserLanguage") as! String
        
        print("当前用户语言:\(userLang)")
        
        var lang: String!=""
        
        switch String(describing: userLang) {
        case "en-US", "en-CN":
            //en
            
            fullScreenNews.bindWithData(image: newArrary[1].imgSrc!, title: newArrary[1].title!, content: newArrary[1].content!)
            
        case "zh-Hans-US","zh-Hans-CN","zh-Hant-CN","zh-TW","zh-HK","zh-Hans":
            //cn
            fullScreenNews.bindWithData(image: newArrary[1].imgSrc!, title: newArrary[1].titleCn!, content: newArrary[1].contentCn!)
            
        default:
            fullScreenNews.bindWithData(image: newArrary[1].imgSrc!, title: newArrary[1].title!, content: newArrary[1].content!)
        }
    
        
    }
    
    func setUpBlankView(){
        
        
        blankView.backgroundColor = UIColor.lightGray
        let blankLabel = UILabel.init(frame: CGRect.init(x:20 , y: screenHeight*0.2, width: screenWidth-40, height: screenHeight*0.2))
        
        let button = UIButton.init(frame: CGRect.init(x:screenWidth*0.3 , y: screenHeight*0.5, width: screenWidth*0.3, height: screenHeight*0.1))
        
        
        button.setTitle("Retry", for:.normal)
        button.addTarget(self, action: #selector(viewDidLoad), for:UIControlEvents.touchUpInside)
        button.backgroundColor = mainColor
        button.layer.cornerRadius = 6
        blankLabel.text = "No Network, please connect WIFI or open your 3G/4G data"
        blankLabel.lineBreakMode = .byClipping
        blankLabel.numberOfLines = 0
        
        blankView.addSubview(blankLabel)
        blankView.addSubview(button)
        
    }
    
    
    @objc func refresh(sender:AnyObject) {
        
        //        dataSource = NSMutableArray()
        
        //        self.loadData()
        
        refreshFirstView()
        
        self.refreshControl?.endRefreshing()
        
    }
    
    @IBAction func callUs(_ sender: Any) {
        makePhoneCall()
    }
    
    func createDropdownFresh() -> Void {
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action:#selector(self.refreshFirstView), for: UIControlEvents.valueChanged)
        
        //table
        //        self.newsTableView?.addSubview(refreshControl!)
        //        self.firstView.addSubview(refreshControl!)
        
        
    }
    
    /*TABLE
     
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
     
     
     let web = URL(string: oneNews.linkUrl!)
     
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
     
     let userLang = UserDefaults.standard.value(forKey: "UserLanguage") as! String
     
     print("当前用户语言:\(userLang)")
     
     
     switch userLang {
     case "zh-Hans":
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
     
     */
    
    func loadData() {
        SVProgressHUD.show()
        let url = hostApiNews+"/news?type=full"
    
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
                        
                        let new = Mapper<News>().map(JSONObject: resultArray[index])
                        print("news date:\(String(describing: new?.date))")
                        
                        self.news.append(new!)
                    }
                    
                    
                    //                    let sortedArray = self.news.sorted(by: {$0.id! > $1.id!})
                    
                    
                    //                    let dateFormatter = DateFormatter()
                    //                    dateFormatter.dateFormat= "yyyy-mm-dd"
                    
                    
                    let sortedArray = self.news.sorted(by: {$0.id! > $1.id!})
                   
                    self.setUpSecondView(newsArray:sortedArray)
                    self.setUpFullScreenNews(newArrary:sortedArray)
                 
                case .failure(let error):
                    print("Request Error:\(error)")
                    
                    SVProgressHUD.dismiss()
                    
                    let networkAlert = getSimpleAlert(titleString: alertString, messgaeLocizeString: "NETWORK_ERROR")
                    self.present(networkAlert, animated: true, completion: nil)
                    return
                    
                }
                //                self.newsTableView!.reloadData()
                SVProgressHUD.dismiss()
        }
    }

    func getLocationID(lat:Double,lng:Double){
        
        
        let locationRequest = "\(AcuuWeatherAPIHost)/locations/v1/cities/geoposition/search?apikey=\(AccuWeatherAPIKey)&q=\(lat),\(lng)"
        
        print(locationRequest)
        Alamofire.request(locationRequest)
            .validate()
            .responseJSON {response in
                switch response.result{
                    
                case .success(let value):
                    let location =  value as! [String:Any]
                    let key = location["Key"] as! String
                    print("locationValue:\(key)")
                    
                    self.getWeatherById(locationKey:key)
                    self.getCurrentWeatherById(locationKey: key)
                    
                case .failure(let error):
                    print("locationerror2:\(error)")
                    
                }
        }
        
    }
    
    
    func getCurrentWeatherById(locationKey:String){
        
        let weatherRequest = "\(AcuuWeatherAPIHost)/currentconditions/v1/\(locationKey)?apikey=\(AccuWeatherAPIKey)"
        
        Alamofire.request(weatherRequest)
            .validate()
            .responseJSON {response in
                switch response.result{
                    
                case .success(let value):
                    
                    let resultArray = value as! NSArray
                    
                    if resultArray.count == 0 {
                        
                        SVProgressHUD.dismiss()
                        
                        return
                    }
                    
                    
                    let accuWeather = Mapper<AccuWeather>().map(JSONObject: resultArray[0])
                    print("current weather:\(accuWeather?.Temperature),\(accuWeather?.WeatherText)")
                    
                    
                    let initString = accuWeather?.WeatherText
                    //                    let weatherString = getWeatherString(initString: initString!)
                    let weatherString = getWeatherStr(iconNo: (accuWeather?.WeatherIcon!)!)
                    
                    print("weatherString\(weatherString)")
                    let temperatureC = temperatureTransfer(tf: Int(accuWeather!.Temperature!))
                    self.weatherView.temperatureLabel.text =  "\(temperatureC)ºC"
                    
                    self.weatherView.timeBucketLabel.text = "Good \(getTimeBucket())"
                    
                    self.weatherView.weatherImageView.image = UIImage(named:"ic_\(weatherString)")
                    //todo test
                    self.weatherView.bgImageView.image = UIImage.gif(name: weatherString)
                    self.weatherView.bgImageView.contentMode = .scaleAspectFill
//                    self.weatherView.bgImageView.image = UIImage.gif(name:"night")
                    
                case .failure(let error):
                    print("locationerror3:\(error)")
                    
                }
        }
        
    }
    
    
    func getWeatherById(locationKey:String){
        let weatherRequest = "\(AcuuWeatherAPIHost)/forecasts/v1/hourly/12hour/\(locationKey)?apikey=\(AccuWeatherAPIKey)"
        
        Alamofire.request(weatherRequest)
            .validate()
            .responseJSON {response in
                switch response.result{
                case .success(let value):
                    
                    let resultArray = value as! NSArray
                    
                    if resultArray.count == 0 {
                        
                        SVProgressHUD.dismiss()
                        
                        return
                    }
                    
                    for index in 0..<resultArray.count{
                        
                        let accuWeather = Mapper<AccuWeather>().map(JSONObject: resultArray[index])
                        print("acc weather:\(accuWeather?.DateTime),\(accuWeather?.IconPhrase),\(accuWeather?.TemperatureF),\(accuWeather?.WeatherIcon)")
                        
                        self.accuWeatherList.append(accuWeather!)
                        self.dataSource.add(accuWeather!)
                        
                    }
                    DispatchQueue.main.async {
                        self.weatherView.forecastTableView.reloadData()
                        
                    }
                    
                case .failure(let error):
                    print("locationerror4:\(error)")
                    
                }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentHour = Calendar.current.component(.hour, from: Date())
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "weatherForecastCell", for: indexPath) as! WeatherTableViewCell
        
        if(self.accuWeatherList.count == 0)
        {
            cell.tempLable.text = "N/AºC"
            
            
            cell.timeLabel.text = "N/Aam"
            
            cell.imageIcon.image = UIImage(named:"ic_cloudy")
            
            
        }
        else{
            
            let temp = accuWeatherList[indexPath.row].TemperatureF!
            let tempString = temperatureTransfer(tf: temp)
            cell.tempLable.text = "\(tempString)ºC"
            
            let time = accuWeatherList[indexPath.row].DateTime
         
            cell.timeLabel.text = getHourString(add: indexPath.row+1)
          
            let imageName = getWeatherStr(iconNo: accuWeatherList[indexPath.row].WeatherIcon!)
            
            cell.imageIcon.image = UIImage(named:"ic_\(imageName)")
            
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height/6
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


extension NewHomeViewController: CLLocationManagerDelegate{
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        
        listLikelyPlaces()
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            
        case .notDetermined:
            print("Location status not determined.")
            
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            currentLocation =  manager.location
            if currentLocation?.coordinate != nil{
                
                print("Location status is OK.current location is:\(currentLocation?.coordinate.latitude),\(currentLocation?.coordinate.longitude)")
                
                getLocationID(lat: (currentLocation?.coordinate.latitude)!, lng: (currentLocation?.coordinate.longitude)!)
                
            }
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        //
        print("locationError1: \(error)")
        
        let networkAlert = getSimpleAlert(titleString: alertString, messgaeLocizeString: "NETWORK_ERROR")
        self.present(networkAlert, animated: true, completion: nil)
        
    }
    // Populate the array with the list of likely places.
    func listLikelyPlaces() {
        // Clean up from previous sessions.
        likelyPlaces.removeAll()
        
        placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
            if let error = error {
                // TODO: Handle the error.
                print("Current Place error: \(error.localizedDescription)")
                return
            }
            
            // Get likely places and add to the list.
            if let likelihoodList = placeLikelihoods {
                for likelihood in likelihoodList.likelihoods {
                    let place = likelihood.place
                    self.likelyPlaces.append(place)
                }
            }
        })
    }
    

    
    
    
}


