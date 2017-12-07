//
//  LocationViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 29/9/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SVProgressHUD
import EAFeatureGuideView

class LocationViewController: UIViewController, GMSMapViewDelegate, UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate{
    
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var telephoneLabel: UILabel!
    @IBOutlet weak var weekendLabel: UILabel!
    @IBOutlet weak var storeTextField: UITextField!
    var branchPicker = UIPickerView()
    
    //    1.Declare the location manager, current location, map view, places client, and default zoom level at the class level.
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView_: GMSMapView!
    var mapView :UIView!
    
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 12.0
   
    //    3.Declare variables to hold the list of likely places, and the user's selected place.
    
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    
    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    // Declare GMSMarker instance at the class level.
    let infoMarker = GMSMarker()
    var storeMarkers = [GMSMarker()]
    var storeMarker : GMSMarker?

    var result:Double = 100000
    var pickerIndex = 0
    var lastSelectedRow = 0
    var pickerIndexChanged :Bool = false
    
    var stores = [StoreAddress]()
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.navigationItem.title = LanguageHelper.getString(key: "BRANCH_LOCATION")
        
         self.navigationController?.tabBarItem.title = LanguageHelper.getString(key: "LOCATION")
        
        if self.revealViewController() != nil {
            self.menuButton?.target = self.revealViewController()
            self.menuButton?.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
//        networkAlert.addAction(UIAlertAction(title: okString, style: UIAlertActionStyle.default, handler: nil))
        
        SVProgressHUD.show()
        stores = dataSource()
        
        
        //     2.Initialize the location manager and GMSPlacesClient in viewDidLoad().
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        self.mapView = UIView.init(frame: CGRect.init(x: 0, y: UIScreen.main.bounds.height*0.4, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.6-49))
        self.view.addSubview(mapView)
        
        let camera = GMSCameraPosition.camera(withLatitude: -34.86, longitude: 151.20, zoom: zoomLevel)
        
        self.mapView_ = GMSMapView.map(withFrame:self.mapView.bounds, camera: camera)
        self.mapView_.isMyLocationEnabled = true
        self.mapView_.settings.myLocationButton = true
        self.mapView_.delegate = self
        
        drawAllMarkers()
        
        //use delegate for hide keyboard
        self.storeTextField.delegate = self
        
        let rightImageView = UIImageView.init(image: UIImage(named:"ic_arrow_drop_down"))
        self.storeTextField.rightViewMode = .always
        self.storeTextField.rightView = rightImageView
        
        SVProgressHUD.dismiss()
//        showFeatureGuideView()
    }
    
    
    
    func showFeatureGuideView(){
      
        let width = UIScreen.main.bounds.width
        let storeItem = EAFeatureItem.init(focus:CGRect(x:20,y:64,width:width-80,height:40), focusCornerRadius: 5, focus: UIEdgeInsets.zero)
     
        storeItem?.introduce = LanguageHelper.getString(key: "STORE")
        self.navigationController?.view.show(with: [storeItem!], saveKeyName: "PickerStore", inVersion: nil)
        
    }
    
    
    @IBAction func pickBranch(_ textField : UITextField) {
        
        print("pickerbranch111111")
        // UIPickerView
        self.branchPicker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.branchPicker.delegate = self
        self.branchPicker.dataSource = self
        self.branchPicker.backgroundColor = UIColor.white
      
        print("pickerbranch111111")
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = mainColor
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title:doneString, style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: cancelString, style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        toolBar.isUserInteractionEnabled = true
          textField.inputView = self.branchPicker
        
        textField.inputAccessoryView = toolBar
        
    }
    
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return branches.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return branches[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerIndex = row

    }
    
    
    //MARK:- TextFiled Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //      self.resignFirstResponder()
        self.pickBranch(textField)
    }
    //MARK:- Button
    @objc func doneClick() {
        
        let placeId = stores[pickerIndex].placeId
        
        changeCamera(id: placeId!)
        
        self.addressLabel.text = stores[pickerIndex].address
        self.storeTextField.text = stores[pickerIndex].title
        self.weekdayLabel.text = stores[pickerIndex].workday
        self.weekendLabel.text = stores[pickerIndex].weekend
        self.addressLabel.text = stores[pickerIndex].address
        
        self.mapView.addSubview(self.mapView_)
        
        self.storeTextField.resignFirstResponder()
//        self.branchPicker.selectRow(pickerIndex, inComponent: 0, animated: true)
    
        
    }
    @objc func cancelClick() {
        self.storeTextField.resignFirstResponder()
    }
    func drawAllMarkers() {
        
        var min = 0
        
        
        for index in 0...7{
            
            let placeId = stores[index].placeId
            
            placesClient.lookUpPlaceID(placeId!, callback: { (place, error) -> Void in
                if let error = error {
                    print("lookup place id query error: \(error.localizedDescription)")
                    return
                }
                
                guard let place = place else {
                    print("No place details for \(String(describing: placeId))")
                    return
                }
                let marker = GMSMarker()
                marker.position = place.coordinate
                let makerLocation = CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude)
                print("drawmarlerPlaceid:\(place.placeID)")
                marker.tracksViewChanges = true
                self.storeMarkers.append(marker)
                marker.map = self.mapView_
                
                if self.currentLocation != nil{
                    let myDistance = Double((self.currentLocation?.distance(from: makerLocation))!)
                    print("my distance:\(myDistance)")
                    
                    if myDistance < self.result{
                        
                        self.result = myDistance
                        print("my result:\(self.result)")
                        
                        min = index
                    }
                    print("min index0:\(min)")
                    
                }
                
                self.addressLabel.text = self.stores[min].address
                self.storeTextField.text = self.stores[min].title
                self.weekdayLabel.text = self.stores[min].workday
                self.weekendLabel.text = self.stores[min].weekend
                self.addressLabel.text = self.stores[min].address
                
                self.mapView.addSubview(self.mapView_)
                
            })
            
        }
        
    
    }

    func changeCamera(id: String){
        placesClient.lookUpPlaceID(id, callback: { (place, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                print("No place details for \(id)")
                return
            }
            
            let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude,
                                                  longitude: place.coordinate.longitude,
                                                  zoom: self.zoomLevel)
            
            let newCamera : GMSCameraUpdate = GMSCameraUpdate.setCamera(camera)
            
            self.mapView_.moveCamera(newCamera)
            print("selected places:\(place.coordinate.latitude),\(place.coordinate.longitude)")
            
        })
        
        
    }
    
    @IBAction func callUs(_ sender: Any) {
        makePhoneCall()
    }
    @IBAction func PrioritySupport(_ sender: Any) {
        
        var controller: PriorityViewController
        
        controller = self.storyboard?.instantiateViewController(withIdentifier: "PriorityViewController") as! PriorityViewController
        
        
        
        present(controller, animated: true, completion: nil)
    }
    
    
    func dataSource () ->[StoreAddress]{
        let lakemba = StoreAddress()
        lakemba.title = "Lakemba Branch"
        lakemba.placeId = "ChIJ03OkmL67EmsRsiKeycQqElU"
        lakemba.address = "6 Frazer Street, Lakemba, NSW"
        
        
        let alexandria = StoreAddress()
        alexandria.title = "Alexandria Branch"
        alexandria.placeId = "EjExNDkgTWl0Y2hlbGwgUmQsIEVyc2tpbmV2aWxsZSBOU1cgMjA0MywgQXVzdHJhbGlh"
        alexandria.address = "8/ 149 Mitchell Road, Alexandria, NSW"
        
        let pymble = StoreAddress()
        pymble.title = "Pymble Branch"
        pymble.placeId = "ChIJmdalXoCoEmsR5dBXNOt4WPE"
        pymble.address = "14-16 Suakin St, Pymble, NSW"
        
        let silverwater = StoreAddress()
        silverwater.title = "Silverwater Branch"
        silverwater.placeId = "ChIJzdgqH6CkEmsRSX6qxkbQkUI"
        silverwater.address = "9 Blaxland Street, Silverwater, NSW"
        
        let yennora = StoreAddress()
        yennora.title = "Yennora Branch"
        yennora.placeId = "ChIJK0ifknm9EmsRRJ5JeSHRg_c"
        yennora.address = "32 Pine Road, Yennora, NSW"
        
        let southgranville = StoreAddress()
        southgranville.title = "South Granville Branch"
        southgranville.placeId = "ChIJ5evRpf68EmsRqMOHOTAcOqk"
        southgranville.address = "86 Ferndell St, South Granville, NSW"
        
        let preston = StoreAddress()
        preston.title = "Preston Branch"
        preston.placeId = "ChIJcQs_IDdE1moRZQ_iiTv1kqA"
        preston.workday = LanguageHelper.getString(key: "WEEKDAY") + " 6.00am - 4.30pm"
        preston.address = "1C Bell Street, Preston, VIC"
        
        let sunshine = StoreAddress()
        sunshine.title = "Sunshine West Branch"
        sunshine.placeId = "ChIJs8ZYbfVg1moRd05ysu9J9u8"
        sunshine.workday =  LanguageHelper.getString(key: "WEEKDAY") + " 6.00am - 4.30pm"
        sunshine.address = "540 Somerville Road, Sunshine West, VIC"

        let localStores = [alexandria,lakemba,pymble,silverwater,yennora,southgranville,preston,sunshine]
        
        return localStores
        
    }
    
    
}
//4.Add delegates to handle events for the location manager, using an extension clause.

extension LocationViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        //        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        if mapView_.isHidden {
            mapView_.isHidden = false
            mapView_.camera = camera
            
        } else {
            mapView_.animate(to: camera)
        }
        
        listLikelyPlaces()
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

