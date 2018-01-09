//
//  TrackingMapViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 25/10/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SVProgressHUD
import ObjectMapper

class TrackingMapViewController: UIViewController,GMSMapViewDelegate {
    
    
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var expectedLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var disLabel: UILabel!
    @IBOutlet weak var updatedLabel: UILabel!
    @IBOutlet weak var updLabel: UILabel!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var trackingMapView_: GMSMapView!
    var realtimeResult:Any?
    var mapView :UIView!
    var result:Any?
    
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 16.0
    
    var speed:Double?
    var suburb: String?
    var slip:String?
    
    var latitude:Double?
    var longtitude:Double?
    var productionLocation: CLLocationCoordinate2D?
    
    var placeid:String?

    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    
    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    // Declare GMSMarker instance at the class level.
    var trunckMarker = GMSMarker()
    
    //    var trunckMarker : GMSMarker?
    //origin &destination string
    var origin:String?
    var destination:String?
    
    var productLoaction: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.disLabel.text = LanguageHelper.getString(key: "DISTANCE")
        self.expectedLabel.text = LanguageHelper.getString(key: "EXPECTED")
        self.updLabel.text = LanguageHelper.getString(key: "UPDATED")
        
        let tracking = Mapper<Tracking>().map(JSONObject: result)!
        
        if let stp = tracking.step {
            
            if stp==4 {
                
                self.suburb = tracking.suburb
                self.slip = tracking.orderNo
                print("staring.......")
                locationManager = CLLocationManager()
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestAlwaysAuthorization()
                locationManager.distanceFilter = 50
                locationManager.startUpdatingLocation()
                
                
                //orgin
                print("getRealtimeResult:\(tracking.orderNo!),\(tracking.suburb!)")
                
                getRealtimeResult(slip: (tracking.orderNo)!, suburb: (tracking.suburb)!)
                
                self.mapView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-152))
                self.view.addSubview(mapView)
                
                placesClient = GMSPlacesClient.shared()
                
            }
            else{
                print("NO REAL TIME")
                
            }
        }
        
        
    }
    
    func getRealtimeResult(slip:String,suburb:String){
        
        SVProgressHUD.show()
        
        let suburbSent = formatingSuburb(suburb:suburb)
        
        let url : String = hostApi+"HLS-REST/location/tracking?pickingSlip="+slip+"&suburb="+suburbSent
        
        print("getRealtimeResult0:\(url)")
        
        Alamofire.request(url)
            .validate()
            .responseJSON {response in
                switch response.result {
                case .success(let value):
                    print("realtimetracking1:\(value)")
                    
                    self.latitude = (value as![String:Any])["latitude"] as? Double
                    
                    self.longtitude = (value as![String:Any])["longitude"] as? Double
                    
                    let lat = self.latitude!
                    let lng = self.longtitude!
                    
                    
                    print("lat:\(lat),lng:\(lng)")
                    let bearing = (value as![String:Any])["bearing"] as! Double
                    
                    
                    let start = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                    
                    
                    //DRAW THE TRUNK
                    self.drawMap(startPosition: start, bearing:bearing)
                    //GET DESTIONATIONPLACEIDVIASUBURB
                    self.getDestinationPlaceid(suburb: self.suburb!,slip: self.slip!) { (placeid) in
                        self.destination = placeid
                        
                        print("destnation1:\(String(describing: self.destination)))")
                        print("origin1:\(String(describing: self.origin))")
                        
                        let requestDistant = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(self.origin!)&destinations=place_id:\(self.destination!)&key=\(APIKey)"
                        print("requestDistant1:\(requestDistant)")
                        
                        self.distanceData(requestURL: requestDistant)
                        
                        let currentTime = getCurrentTimeString()
                        self.updatedLabel.text = currentTime
                        
                        
                    }
                    
                    
                    
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    
                    print("realtimetracking0.5:\(error)")
                                            let networkAlert = getSimpleAlert(titleString: alertString, messgaeLocizeString: "NO_REALTIME")
//                                            self.present(networkAlert, animated: true, completion: nil)
                    
                    
                    self.present(networkAlert, animated: true, completion: {
                        self.view.isHidden = true
                    })
                    
                    
                    /*
                    
                    let tempstart = CLLocationCoordinate2D(latitude:-33.9115061 , longitude: 151.0747764)
                    let bearing = 60.0
                    self.speed = 30
                    
                    self.getDestinationPlaceid(suburb: self.suburb!,slip: self.slip!) { (placeid) in
                        self.destination = placeid
                        
                        
                        if let dest = placeid {
                            
                            print("destnation0.5:\(dest)")
                            print("origin0.5:\(String(describing: self.origin))")
                            
                            let requestDistant = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(self.origin!)&destinations=place_id:\(dest)&key=\(APIKey)"
                            print("requestDistant0.5:\(requestDistant)")
                            
                            self.distanceData(requestURL: requestDistant)
                            
                        }
                        else {
                            
                            print("no distance")
                        }
                        
                    }
                    
                    
                    self.drawMap(startPosition: tempstart, bearing:bearing)
                    */
                    return
                }
                SVProgressHUD.dismiss()
        }
    }
    
    
    
    
    func drawMap(startPosition:CLLocationCoordinate2D,bearing:Double){
        
        let truckCamer = GMSCameraPosition.camera(withLatitude:(startPosition.latitude), longitude: (startPosition.longitude), zoom: zoomLevel)
        
        
        self.trackingMapView_ = GMSMapView.map(withFrame:self.mapView.bounds, camera: truckCamer)
        
        
        self.trackingMapView_.isMyLocationEnabled = true
        self.trackingMapView_.settings.myLocationButton = true
        
        self.trackingMapView_.delegate = self
        
        let markerImage = UIImage.init(named: "truck")?.withRenderingMode(.alwaysTemplate)
        
        let markerView = UIImageView.init(image: markerImage)
        
        markerView.transform = markerView.transform.rotated(by: CGFloat(.pi*bearing/180))
        
        print("bearing:\(bearing)")
        
        markerView.tintColor = mainColor
        
        let marker = GMSMarker()
        marker.position = startPosition
        marker.iconView = markerView
        marker.map = self.trackingMapView_
        self.trunckMarker = marker
        
        self.mapView.addSubview(self.trackingMapView_)
        
        
        self.origin = "\(startPosition.latitude),\(startPosition.longitude)"
        print("start:\(String(describing: self.origin))")
        //        getSuburbCoordinate(suburb: self.suburb, orign: origin)
        
        
        
    }
    
    
    func getDestinationPlaceid(suburb:String,slip:String,completion:@escaping (_ result: String?)->()) {
        
        let suburbSent = formatingSuburb(suburb:suburb)
        
        
        
        let state = checkState(slip:slip)
        
        
        let suburbRequest = "https://maps.googleapis.com/maps/api/geocode/json?address=\(suburbSent),+\(state)&key=\(APIKey)"
        
        
        Alamofire.request(suburbRequest)
            .validate()
            .responseJSON {
                response in
                
                switch response.result{
                case .success(let value):
                    
                    print("getDestination1:\(value)")
                    
                    
                    let rows = (value as![String:Any])["results"] as! NSArray
                    let first = rows[0] as! [String:Any]
                    let placeid = first["place_id"] as! String
                    let dest = placeid
                    
                    completion(dest)
                    
                    print("getDestination2:\(dest)")
                    let markerImage = UIImage.init(named: "truck")?.withRenderingMode(.alwaysTemplate)
                    
                    
                    self.placesClient.lookUpPlaceID(dest, callback: { (place, error) in
                        
                        if let error = error{
                            print("lookup place id query error: \(error.localizedDescription)")
                            return
                        }
                        
                        guard let place = place else {
                            print("No place details for \(String(describing: dest))")
                            return
                        }
                        
                        let homeMarkerView = UIImageView.init(image: UIImage.init(named: "ic_home"))
                        
                        let homeMarker = GMSMarker()
                        homeMarker.iconView = homeMarkerView
                        homeMarker.position = place.coordinate
                        
                        homeMarker.map = self.trackingMapView_
                        
                    })
                    
                    
                    
                case .failure(let error):
                    
                    completion(nil)
                    
                    print("Destination Request Error:\(error)")
                }
                
                
        }
        
        
    }
    
    
    func distanceData(requestURL: String){
        
        
        Alamofire.request(requestURL)
            .validate()
            .responseJSON {
                response in
                
                switch response.result{
                case .success(let value):
                    
                    print("value:\(value)")
                    
                    let rows = (value as![String:Any])["rows"] as! NSArray
                    let first = rows[0] as! [String:Any]
                    let element = first["elements"] as! NSArray
                    let elementF = element[0] as! [String:Any]
                    
                    if let duration1 = elementF["duration"] {
                        
                        let duration = duration1 as! [String:Any]
                        
                        let text = duration["text"] as! String
                        print("text:\(text)")
                        self.timeLabel.text = text
                        
                        
                        let distance = elementF["distance"] as! [String:Any]
                        print("distance:\(distance)")
                        let disText = distance["text"] as! String
                        print("disText:\(disText)")
                        
                        self.distanceLabel.text = disText
                    }
                        
                    else{
                    }

                case .failure(let error):
                    
                    print("Request Error:\(error)")
                }
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

//4.Add delegates to handle events for the location manager, using an extension clause.

extension TrackingMapViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        
        var origin = ""
        if let originLocation = productLoaction{
            origin = "\(originLocation.latitude),\(originLocation.longitude)"
        }
        
        var destination = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        
        let url = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(origin)&destinations=\(destination)&key=\(APIKey)"
        
        print("timerequesturl \(url)")
        
        
        distanceData(requestURL: url)
        
        
        
    }
    
    
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            currentLocation =  manager.location
            if currentLocation?.coordinate != nil{
                print("Location status is OK")
                
            }
            
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    
}

