//
//  TrackingResultViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 4/10/17.
//*  This is for real time tracking, may be use in version 2
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import ObjectMapper
import SVProgressHUD

class TrackingResultViewController: UIViewController,GMSMapViewDelegate{
    
    var detailVC: TrackingDetailViewController?
    var mapVC: TrackingMapViewController?
   
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var firstView: UIView!
    
    var result :Any?
    var allowRealtime :Bool = false
    
    @IBOutlet weak var segment: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.title = LanguageHelper.getString(key: "RESULT")
        segment.setTitle(LanguageHelper.getString(key: "DETAIL"), forSegmentAt: 0)
        segment.setTitle(LanguageHelper.getString(key: "MAP"), forSegmentAt: 1)
        
        self.secondView.isHidden = false
        self.firstView.isHidden = true
        
        let tracking = Mapper<Tracking>().map(JSONObject: result)!
       
        
        if let stp = tracking.step{
            if stp == 4 {
                allowRealtime = true
                ifAllowRealtime = true
            }
            else{
                
                ifAllowRealtime = false
            }
            segment.setEnabled(ifAllowRealtime, forSegmentAt: 1)
        }
        print("RESULT:\(tracking.step),\(allowRealtime),\(ifAllowRealtime)")
    }

    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            self.firstView.isHidden = true
            self.secondView.isHidden = false
        }
        else if sender.selectedSegmentIndex == 1 {
            
                self.firstView.isHidden = false
                self.secondView.isHidden = true
        }
    }
    
    @IBAction func call(_ sender: Any) {
        makePhoneCall()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "trackingDetail" {
            detailVC = segue.destination as! TrackingDetailViewController
            detailVC?.result = result
        }
        if segue.identifier == "trackingMap" {
            
             mapVC = segue.destination as! TrackingMapViewController
             mapVC?.result = result
        }
    }
}


