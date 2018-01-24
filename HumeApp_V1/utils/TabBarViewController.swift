//
//  TabBarViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 9/11/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

   
    @IBOutlet weak var customTabbar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
      let items = self.customTabbar.items!
     
      var titles = [LanguageHelper.getString(key: "HOME"),LanguageHelper.getString(key: "TRACK"),LanguageHelper.getString(key: "NEWS"),LanguageHelper.getString(key: "LOCATION")]
//        ,LanguageHelper.getString(key: "SPECIAL")]
        
        
        for i in 0..<items.count{
            items[i].title = titles[i]
            
        }
        
       

        // Do any additional setup after loading the view.
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
