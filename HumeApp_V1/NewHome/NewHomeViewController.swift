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
import GoogleMaps
import GooglePlaces

class NewHomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SFSafariViewControllerDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
   
    
    
    var firstView: UIView?
    
    let weatherLabel = UILabel.init(frame: CGRect.init(x:UIScreen.main.bounds.width*0.6 , y: 10, width: UIScreen.main.bounds.width*0.3, height: 80))
    
    let weatherImageView = UIImageView.init(frame:CGRect.init(x: UIScreen.main.bounds.width*0.6, y: 100, width: 80, height: 80))
    
    
    var secondView: UIView?
    var thirdView :UIView?
    
    
    var newsTableView: UITableView!
    var dataSource : NSMutableArray = NSMutableArray()
    var refreshControl: UIRefreshControl?
        var photoGallery = MLPhotoGallery.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-44))
//
    var images = ["morning","afternoon","evening"]
   
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
     var likelyPlaces: [GMSPlace] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            self.menuButton?.target = self.revealViewController()
            self.menuButton?.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let titleImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        
        titleImageView.image = UIImage(named:"titleLogo")
        titleImageView.contentMode = .scaleAspectFit
        
        self.navigationItem.titleView = titleImageView
        
        //get current loaction
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        
        
   //first view setting
        
        firstView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-44))
        
        
        let bgImageView = UIImageView.init(frame:CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-44))
        
        bgImageView.image = UIImage(named:"\(getTimeBucket())")
        
        firstView?.addSubview(bgImageView)
        
        
        
        
//        let weatherLabel = UILabel.init(frame: CGRect.init(x:UIScreen.main.bounds.width*0.6 , y: 10, width: UIScreen.main.bounds.width*0.3, height: 80))
//
        self.weatherLabel.text = "25ºC"
        self.weatherLabel.textColor = UIColor.white
        self.weatherLabel.font = UIFont.init(name: "Helvetica-Bold", size: 50)
        
        bgImageView.addSubview(self.weatherLabel)
        
        
        let timeLabel = UILabel.init(frame: CGRect.init(x:20 , y: UIScreen.main.bounds.height*0.2, width: UIScreen.main.bounds.width*0.7, height: UIScreen.main.bounds.height*0.2))
        
        
        timeLabel.text = "Good \(getTimeBucket())"
        timeLabel.textColor = UIColor.white
        timeLabel.font = UIFont.init(name: "Helvetica-Bold", size: 50)
        timeLabel.textAlignment = .left
        
        timeLabel.lineBreakMode = .byClipping
        timeLabel.numberOfLines = 0
        bgImageView.addSubview(timeLabel)
        
    
        
        self.weatherImageView.image = UIImage(named:"01d")
        
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
    
    
    func getWeatherInfo(){
        
          SVProgressHUD.show()
        
         print("Location status is OK.current location is222:\(currentLocation?.coordinate.latitude),\(currentLocation?.coordinate.longitude)")
      
        
        let latitue :Double = (currentLocation?.coordinate.latitude)!
        let longitude = (currentLocation?.coordinate.longitude)!

        let weatheRequest = "http://api.openweathermap.org/data/2.5/weather?lat=\(latitue)&lon=\(longitude)&appid=\(waetherAPIKEY)"
        
        print("weatherReqest:\(weatheRequest)")
        
        Alamofire.request(weatheRequest)
            .validate()
            .responseJSON {response in
                switch response.result {
                case .success(let value):
                    
                    print("weather value:\(value)")
                    
                    
                    let weatherResult = Mapper<Weather>().map(JSONObject:value)!

                    print("weatherResult0:\(weatherResult)")
//
                    print("weatherResult1:\(String(describing: weatherResult.temperatureK)),\(String(describing: weatherResult.coord)),\(weatherResult.id),\(weatherResult.base),\(weatherResult.wind),\(weatherResult.weather)")
                    
                    let weatherDetails:[WeatherDetail] = weatherResult.weather!
                    print("weatherResult2:\(weatherDetails.count)")
                    
                    let weatherDetail = weatherDetails[0].icon
                    
                    
                    
//                    http://openweathermap.org/img/w/10d.png
                    
                    
                    
                    print("weatherResult3:\(String(describing: weatherDetail))")
                    
                    DispatchQueue.main.async {
                        
                        
                        let temperatureC = kelvinToCelsius(kelvin: weatherResult.temperatureK!)
                        
                        print("weatherC:\(temperatureC)")
                        self.weatherLabel.text = "\(temperatureC)ºC"
                        
                        self.weatherImageView.image = UIImage(named:weatherDetail!)
                      
                    }
                    
  
                case .failure(let error):
                    print("Request Error:\(error)")
                    
                    SVProgressHUD.dismiss()
                    
                    let networkAlert = getSimpleAlert(titleString: alertString, messgaeLocizeString: "NETWORK_ERROR")
                    self.present(networkAlert, animated: true, completion: nil)
                    return
                    
                }
              
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


extension NewHomeViewController: CLLocationManagerDelegate {
    
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
                
                getWeatherInfo()
                
            }
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
//
        print("Error: \(error)")
        
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


