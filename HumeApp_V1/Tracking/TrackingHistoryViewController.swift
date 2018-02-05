//
//  TrackingHistoryViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 4/10/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit
import ObjectMapper
import SVProgressHUD
import Alamofire

class TrackingHistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet weak var clearButton: UIBarButtonItem!
    var dataSource : NSMutableArray = NSMutableArray()
     var refreshControl: UIRefreshControl?
    
//    let historys = History.allHistoryFromDB()
   
    @IBOutlet weak var historyTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.historyTableView.dataSource = self
        self.historyTableView.delegate = self
        
        self.title =  LanguageHelper.getString(key: "TRACKING_HISTORY")
//         networkAlert.addAction(UIAlertAction(title: okString, style: UIAlertActionStyle.default, handler: nil))
//
      dataSource = History.allHistoryFromDB()
        
        print("historyDataSource:\(dataSource.count)")
        
       let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        
        self.clearButton.isEnabled = ifHistoryExist
      
        createDropdownFresh()
        
    }
    func createDropdownFresh() -> Void {
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action:#selector(refresh), for: UIControlEvents.valueChanged)
        self.historyTableView.addSubview(self.refreshControl!)
        
    }
    
    @objc func refresh(sender:AnyObject) {
        
       
        
        self.historyTableView.reloadData()
        
        self.refreshControl?.endRefreshing()
        
    }

    @IBAction func clearHistrory(_ sender: Any) {
       
        let deleteHistorytAlert = UIAlertController(title: deleteString, message: LanguageHelper.getString(key: "DELETE_HISTORY"), preferredStyle: UIAlertControllerStyle.alert)
        
        deleteHistorytAlert.addAction(UIAlertAction(title: deleteString, style: UIAlertActionStyle.default, handler: { action in
            
            // do something like...
           
            History.deleteAllItems()
           
            
            self.dataSource.removeAllObjects()
            self.historyTableView.reloadData()
            
            ifHistoryExist = false
            self.clearButton.isEnabled = ifHistoryExist
            
        }))
        
        deleteHistorytAlert.addAction(UIAlertAction(title: cancelString, style: UIAlertActionStyle.cancel, handler: nil))
        
        
        
        self.present(deleteHistorytAlert, animated: true, completion: nil)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
      
        if dataSource.count>0 {
            return 1
        }
        else{
            
            TableViewHelper.EmptyMessage(message: LanguageHelper.getString(key: "NO_HISTORY"), viewController: tableView)
            
            return 0
            
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if dataSource.count>0 {
            return dataSource.count
        }
        else {
            return 0
        }
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as! HistoryTableViewCell
        let oneHistory =  self.dataSource[indexPath.row] as! History
        
        cell.slipNumberLabel.text = oneHistory.slipNumber?.uppercased()
        cell.dateLabel.text = oneHistory.trackingTime
        cell.suburbLabel.text = oneHistory.suburb?.uppercased()
        
        return cell
        
    }
    @IBAction func call(_ sender: Any) {
        makePhoneCall()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as! HistoryTableViewCell
        let oneHistory =  self.dataSource[indexPath.row] as! History
        
        let number = oneHistory.slipNumber
        let suburb = oneHistory.suburb
        
        
        getTrackingResult(slip:number!,suburb:suburb!)
        
        
        
    }
    
    func getTrackingResult(slip:String,suburb:String){
        
        SVProgressHUD.show()
        
        
        let whiteSpace = NSCharacterSet.whitespacesAndNewlines
        
        let suburbSent = suburb.trimmingCharacters(in: whiteSpace).replacingOccurrences(of: " ", with: "%20")
        print("suburbSent0:\(suburbSent)")
        
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
                        
                        
                        
                        let newHistory = History.init(slipNumber: slip, suburb: suburb, trackingTime: currentTime)
                        
                        if newHistory.insertSelfToDB(){
                            
                            print("history saved")
                            
                        }
                        
   
                     
                        let trackingModel = (value as! [String:Any]) ["trackingModel"] as! [String:Any]
                        
                        self.performSegue(withIdentifier: "trackingResult2", sender: trackingModel)
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

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "trackingResult2" {
            
            let nextViewController = segue.destination as! TrackingResultViewController
            
            nextViewController.result = sender
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
