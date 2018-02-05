//
//  TrackingViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 29/9/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SQLite3
import Alamofire
import GoogleMaps
import GooglePlaces
//import SearchTextField
import EAFeatureGuideView


class TrackingViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var callButton: UIBarButtonItem!
    @IBOutlet weak var priorityButton: UIBarButtonItem!
    
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var trackButton: UIButton!
    
    @IBOutlet weak var SlipeTextField: UITextField!
    @IBOutlet weak var suburbTextField: UITextField!
    
    
    
    @IBOutlet weak var trackingDes: UILabel!
    @IBOutlet weak var pickingLabel: UILabel!
    @IBOutlet weak var suburbLabel: UILabel!
    
    @IBOutlet weak var navItem: UINavigationItem!
    var alertNo = 0
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.title = LanguageHelper.getString(key: "DELIVERY_TRACKING")
        self.navigationController?.tabBarItem.title = LanguageHelper.getString(key: "TRACKING")
        self.trackingDes.text = LanguageHelper.getString(key: "TRACKING_DES")
        self.pickingLabel.text = LanguageHelper.getString(key: "PICKING")
        self.suburbLabel.text = LanguageHelper.getString(key: "SUBURB")
        self.trackButton.setTitle(LanguageHelper.getString(key: "TRACK"), for: .normal)
        self.historyButton.setTitle(LanguageHelper.getString(key: "HISTORY"), for: .normal)
        
        self.navigationItem.leftBarButtonItem = self.menuButton
    
        self.SlipeTextField.configKeyboard()
        self.suburbTextField.configKeyboard()
        
        if self.revealViewController() != nil {
            self.menuButton?.target = self.revealViewController()
            self.menuButton?.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        self.SlipeTextField.delegate = self
        
        self.trackButton.layer.cornerRadius = 5
        self.historyButton.layer.cornerRadius = 5
        
        //点击其他部分收起键盘
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        
        slipAlert.addAction(UIAlertAction(title: okString, style: UIAlertActionStyle.default, handler: nil))
        suburbAlert.addAction(UIAlertAction(title: okString, style: UIAlertActionStyle.default, handler: nil))
        recordAlert.addAction(UIAlertAction(title: okString, style: UIAlertActionStyle.default, handler: nil))
        //教程页
        //        showFeatureGuideView()
        
        
    }
    
    func showFeatureGuideView(){
        let width = UIScreen.main.bounds.width
        
        let priorityItem = EAFeatureItem.init(focus: CGRect(x:width-110,y:20,width:50,height:50), focusCornerRadius: 25, focus: UIEdgeInsets.zero)
        priorityItem?.introduce = LanguageHelper.getString(key: "PRIORITY")
        self.navigationController?.view.show(with: [priorityItem!], saveKeyName: "tracking", inVersion: nil)
        
    }
    
    
    @IBAction func TrackingClicked(_ sender: Any) {
        
        if suburbTextField?.text?.isEmpty ?? true {
            
            let emptyAlert = getSimpleAlert(titleString:alertString,messgaeLocizeString:"FILL_ERROR")
            self.present(emptyAlert, animated: true, completion: nil)
            return
        }
        
        if SlipeTextField?.text?.isEmpty ?? true {
            let emptyAlert = getSimpleAlert(titleString:alertString,messgaeLocizeString:"FILL_ERROR")
            self.present(emptyAlert, animated: true, completion: nil)
            return
        }
        
        if slipMatcher.match(input: SlipeTextField.text!){
        }
        else{
            self.present(slipAlert, animated: true, completion: nil)
            return
        }
        if suburbMatcher.match(input: suburbTextField.text!){
            
        }
        else{
            self.present(suburbAlert, animated: true, completion: nil)
            return
        }
        
        let slipString = self.SlipeTextField.text!
        let suburbString = self.suburbTextField.text!
        
        getTrackingResult(slip: slipString,suburb: suburbString)
        
    }
    
    func getTrackingResult(slip:String,suburb:String){
        
        SVProgressHUD.show()
        
        let whiteSpace = NSCharacterSet.whitespacesAndNewlines
        
        let suburbSent = suburb.trimmingCharacters(in: whiteSpace).replacingOccurrences(of: " ", with: "%20")
        
        let url : String = hostApi+"/tracking?pickingSlip="+slip+"&suburb="+suburbSent
        
        Alamofire.request(url)
            .validate()
            .responseJSON {response in
                switch response.result {
                case .success(let value):
                    
                    let status = (value as! [String:Any]) ["status"] as! Int
                    
                    if status == 1 {
                        
                        let currentDateTime = Date()
                        
                        // initialize the date formatter and set the style
                        let formatter = DateFormatter()
                        formatter.timeStyle = .medium
                        formatter.dateStyle = .long
                        
                        // get the date time String from the date object
                        let currentTime = formatter.string(from: currentDateTime)
                        
                        print("tracking time:\(currentTime)")
                        let newHistory = History.init(slipNumber: self.SlipeTextField.text!, suburb: self.suburbTextField.text!, trackingTime: currentTime)
                        
                        if newHistory.insertSelfToDB(){
                            
                            print("history saved")
                            
                        }
                        
                        let trackingModel = (value as! [String:Any]) ["trackingModel"] as! [String:Any]
                        
                        self.performSegue(withIdentifier: "trackingResult", sender: trackingModel)
                        ifHistoryExist = true
                    }
                    else{
                        self.present(recordAlert, animated: true, completion: nil)
                    }
                    
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    
                    let networkAlert = getSimpleAlert(titleString: alertString, messgaeLocizeString: "NETWORK_ERROR")
                    self.present(networkAlert, animated: true, completion: nil)
                    
                    return
                }
                SVProgressHUD.dismiss()
        }
    }
    
    
    
    @IBAction func trackingHistory(_ sender: Any) {
        
        self.performSegue(withIdentifier: "trackingHistory", sender: nil)
    }
    
    
    @IBAction func callUs(_ sender: Any) {
        makePhoneCall()
    }
    
    @IBAction func proityRequest(_ sender: Any) {
        
        var controller: PriorityViewController
        
        controller = self.storyboard?.instantiateViewController(withIdentifier: "PriorityViewController") as! PriorityViewController
        
        present(controller, animated: true, completion: nil)
        
    }
    
    
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "trackingResult" {
            
            let nextViewController = segue.destination as! TrackingResultViewController
            
            nextViewController.result = sender
        }
        
    }
    
    
}
