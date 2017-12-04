//
//  SlipViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 5/10/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit
import ObjectMapper

class SlipViewController: UIViewController {
    
    //trackingModel =     {
    //    expectedDate = "05/10/2017";
    //    orderNo = "SGR/147552";
    //    schedule = "1st AM";
    //    status = "Order Dispatched";
    //    step = 4;
    //    suburb = RYDE;
    //    timestamps =         {
    //        confirmed = "10:39 AM 04/10/2017";
    //        delivered = "-";
    //        dispatched = "08:07 AM 05/10/2017";
    //        prepared = "03:23 PM 04/10/2017";
    //        scheduled = "11:55 AM 04/10/2017";
    //    };
    //};
    var result :Any?
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var orderNoLabel: UILabel!
   
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var suburbLabel: UILabel!
    
    @IBOutlet weak var comfirmedLabel: UILabel!
    @IBOutlet weak var dispatchedLabel: UILabel!
    @IBOutlet weak var preparedLabel: UILabel!
    @IBOutlet weak var deliveredLabel: UILabel!
    @IBOutlet weak var scheduledLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tracking = Mapper<Tracking>().map(JSONObject: result)
        
//        self.dateLabel.text = tracking?.expectedDate
      
        self.orderNoLabel.text = LanguageHelper.getString(key: "ORDER_NO")+":  "+(tracking?.orderNo)!
        self.scheduleLabel.text = LanguageHelper.getString(key: "SCHEDULE")+":  "+(tracking?.schedule)!
        self.statusLabel.text = LanguageHelper.getString(key: "STATUS")+":  "+(tracking?.status ?? "")
        self.suburbLabel.text = LanguageHelper.getString(key: "SUBURB")+":  "+(tracking?.suburb)!
        
        self.comfirmedLabel.text = tracking?.confirmed
        self.dispatchedLabel.text = tracking?.dispatched
        self.deliveredLabel.text = tracking?.delivered
        self.scheduledLabel.text = tracking?.scheduled
        self.preparedLabel.text = tracking?.prepared
        
      
        
        // Do any additional setup after loading the view.
    }
    
   
    @IBAction func support(_ sender: Any) {
        var controller: PriorityViewController
        
        controller = self.storyboard?.instantiateViewController(withIdentifier: "PriorityViewController") as! PriorityViewController
        
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func call(_ sender: Any) {
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
