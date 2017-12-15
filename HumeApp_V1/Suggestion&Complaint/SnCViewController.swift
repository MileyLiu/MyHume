//
//  SnCViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 10/11/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit

class SnCViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var suggestionTable: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            self.menuButton?.target = self.revealViewController()
            self.menuButton?.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.navigationItem.title = "\(LanguageHelper.getString(key: "SUGGESTION")) & \(LanguageHelper.getString(key: "COMPLAINT"))"
        
        self.suggestionTable.delegate = self
        self.suggestionTable.dataSource = self
        // Do any additional setup after loading the view.
    }

    
    @IBAction func phoneCall(_ sender: Any) {
         makePhoneCall()
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            
            return LanguageHelper.getString(key: "SUGGESTION")
        }
        else {
            return LanguageHelper.getString(key: "COMPLAINT")
            
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            
            return suggestions.count
        }
        else {
            
            return complaints.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestionCell") as! UITableViewCell
        if indexPath.section == 0 {
            
            cell.textLabel?.text = LanguageHelper.getString(key:suggestions[indexPath.row])
            
//             cell.textLabel?.text = "\(LanguageHelper.getString(key: "SUGGESTION")) \(LanguageHelper.getString(key: "CATEGORY"))  \(indexPath.row+1)"
        }
        else {
            
            cell.textLabel?.text = LanguageHelper.getString(key: complaints[indexPath.row])

        }
       
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
       
        
        if indexPath.section == 0 {
            

            var nextTitle = LanguageHelper.getString(key:suggestions[indexPath.row])
            
            self.performSegue(withIdentifier: "suggestion", sender:nextTitle)
            
            
            
        }else {
            
            
          
//
             var nextTitle = LanguageHelper.getString(key:complaints[indexPath.row])

            self.performSegue(withIdentifier: "complaint1", sender:nextTitle)
         
        }
//        else{
//
//            var nextTitle = LanguageHelper.getString(key:complaints[indexPath.row])
//
//            self.performSegue(withIdentifier: "complaint2", sender:nextTitle)
//        }
        
        
    }
    
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "suggestion"{
            
            let nextController = segue.destination as! SuggestionViewController
            nextController.titleString = sender as? String
        }
        if segue.identifier == "complaint1"{
            //todo
          
            let nextController = segue.destination as! ComplaintViewController
            nextController.titleString = sender as? String
        }
        
//        if segue.identifier == "complaint2"{
//            //todo
//            //            let nextController = segue.destination as! ComplaintViewController
//            let nextController = segue.destination as! ConversationViewController
//            nextController.titleString = sender as? String
//        }
        
        
    }
    

}
