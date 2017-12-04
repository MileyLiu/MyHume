//
//  TrackingDetailViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 25/10/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit
import ObjectMapper

class TrackingDetailViewController: UIViewController {
    var result :Any?
    @IBOutlet weak var orderNoLabel: UILabel!
    
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var suburbLabel: UILabel!
    
    @IBOutlet weak var comfirmedLabel: UILabel!
    @IBOutlet weak var preparedLabel: UILabel!
    @IBOutlet weak var scheduledLabel: UILabel!
    @IBOutlet weak var dispatchedLabel: UILabel!
    @IBOutlet weak var deliveredLabel: UILabel!
    
    
    @IBOutlet weak var deliveryStatusLabel: UILabel!
    
    @IBOutlet weak var historyTrackingLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tracking = Mapper<Tracking>().map(JSONObject: result)
        
        self.orderNoLabel.text = LanguageHelper.getString(key: "ORDER_NO")+":  "+(tracking?.orderNo)!
        self.scheduleLabel.text = LanguageHelper.getString(key: "SCHEDULE")+":  "+(tracking?.schedule)!
        self.statusLabel.text = LanguageHelper.getString(key: "STATUS")+":  "+(tracking?.status ?? "")
        self.suburbLabel.text = LanguageHelper.getString(key: "SUBURB")+":  "+(tracking?.suburb)!
        
        self.comfirmedLabel.text = tracking?.confirmed
        self.dispatchedLabel.text = tracking?.dispatched
        self.deliveredLabel.text = tracking?.delivered
        self.scheduledLabel.text = tracking?.scheduled
        self.preparedLabel.text = tracking?.prepared
        
        self.deliveryStatusLabel.text = LanguageHelper.getString(key: "DELIVERY_STATUS")
        self.historyTrackingLabel.text = LanguageHelper.getString(key: "TRACKING_HISTORY")
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func call(_ sender: Any) {
        makePhoneCall()
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
