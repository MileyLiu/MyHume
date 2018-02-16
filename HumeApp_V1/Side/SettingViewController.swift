//
//  SettingViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 30/10/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController,UIGestureRecognizerDelegate {

    
//    @IBOutlet weak var menuButton: UIBarButtonItem!
    
//    @IBOutlet weak var languageTextView: UITextField!
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var cacheLabel: UILabel!
    @IBOutlet weak var clearCacheView: UIView!
    @IBOutlet weak var languageView: UIView!
    
    @IBOutlet weak var switchLabel: UILabel!
    
    @IBOutlet weak var notificationLabel: UILabel!
    
    @IBOutlet weak var clearLabel: UILabel!
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    // 取出cache文件夹目录 缓存文件都在这个目录下
    let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.popView.layer.cornerRadius = 10
        self.cancelButton.layer.cornerRadius = 10
//        self.title = LanguageHelper.getString(key: "SETTING")
       
//        if self.revealViewController() != nil {
//            menuButton.target = self.revealViewController()
//            menuButton.action = "revealToggle:"
//       self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//        }
        
        self.languageLabel.text = LanguageHelper.getString(key: "LANG")
        
        self.switchLabel.text = LanguageHelper.getString(key: "LANGUGAE_SWITCH")
        
        self.clearLabel.text = LanguageHelper.getString(key: "CACHE")
        
        self.notificationLabel.text = LanguageHelper.getString(key: "NOTIFICTAION")
  
        self.cacheLabel.text = "\(fileSizeOfCache()) M"
        
        let cacheGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.clearTap(_:)))
         cacheGestureRecognizer.delegate = self
        
        self.clearCacheView.addGestureRecognizer(cacheGestureRecognizer)
        self.clearCacheView.isUserInteractionEnabled = true
    
        let langGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.langTap(_:)))
        langGestureRecognizer.delegate = self

        self.languageView.addGestureRecognizer(langGestureRecognizer)

        self.languageView.isUserInteractionEnabled = true
        
        
     
    }
    
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @objc internal func clearTap(_ gesture: UITapGestureRecognizer) {
        
        if gesture.state == UIGestureRecognizerState.ended {
           
            let alert = UIAlertController(title:clearString, message: LanguageHelper.getString(key: "CLEAR_CACHE"), preferredStyle: UIAlertControllerStyle.alert)
            
            
            alert.addAction(UIAlertAction(title: LanguageHelper.getString(key: "OK"), style: UIAlertActionStyle.default, handler: { action in
                self.clearCache()
                 self.cacheLabel.text = "\(self.fileSizeOfCache()) M"
                
            }))
            
            alert.addAction(UIAlertAction(title: cancelString, style: UIAlertActionStyle.cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
           
        }
    }
    
    @objc internal func langTap(_ gesture: UITapGestureRecognizer) {
        
        if gesture.state == UIGestureRecognizerState.ended {
            print("change LAN.......")
            
           let actionSheetController: UIAlertController = UIAlertController(title: LanguageHelper.getString(key: "LANGUGAE"), message: "", preferredStyle: .actionSheet)
            
            
            let cancelActionButton = UIAlertAction(title: LanguageHelper.getString(key: "CANCEL"), style: .cancel) { _ in
                print("Cancel")
            }
            
            let EnglishActionButton = UIAlertAction(title: "English", style: .default) { _ in
                print("eNGLISH")
               
                LanguageHelper.shareInstance.setLanguage(langeuage: "en")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LanguageChanged"), object: nil)
                
                self.refresh()
                
                NotificationCenter.default.post(
                    name: Notification.Name(rawValue: "changeLanguage"), object: nil, userInfo: nil)
             
            }
            
            let ChineseActionButton = UIAlertAction(title: "简体中文", style: .default) { _ in
              
                
                LanguageHelper.shareInstance.setLanguage(langeuage: "zh-Hans")
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LanguageChanged"), object: nil)
                self.refresh()
                
                NotificationCenter.default.post(
                    name: Notification.Name(rawValue: "changeLanguage"), object: nil, userInfo: nil)
                
            }
            
            actionSheetController.addAction(cancelActionButton)
            actionSheetController.addAction(EnglishActionButton)
            actionSheetController.addAction(ChineseActionButton)
            self.present(actionSheetController, animated: true, completion: nil)
           
            
        }
    }
    
    
    func refresh(){
        
        self.languageLabel.text = LanguageHelper.getString(key: "LANG")
        
        self.switchLabel.text = LanguageHelper.getString(key: "LANGUGAE_SWITCH")
        
        self.clearLabel.text = LanguageHelper.getString(key: "CACHE")
        
        self.notificationLabel.text = LanguageHelper.getString(key: "NOTIFICTAION")
        
        self.title = LanguageHelper.getString(key: "SETTING")
        
    }
    
    
    
    func fileSizeOfCache()-> Double {

        // 取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        
        //快速枚举出所有文件名 计算文件大小
        var size = 0.0
        for file in fileArr! {
            
            // 把文件名拼接到路径中
            let path = cachePath?.appending("/\(file)")
            // 取出文件属性
            let floder = try! FileManager.default.attributesOfItem(atPath: path!)
            // 用元组取出文件大小属性
            for (abc, bcd) in floder {
                // 累加文件大小
                if abc == FileAttributeKey.size {
                    size += (bcd as AnyObject).doubleValue
                    
                  
                }
            }
        }
        let mm = Double(round(10*size / 1024.0 / 1024.0)/10)
        
        return mm
    }
    
    
    func clearCache() {
        
        
        print("clearCache.......")
       
        // 取出文件夹下所有文件数组
         let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        
        // 遍历删除
        for file in fileArr! {
            
            let path = cachePath?.appending("/\(file)")
            if FileManager.default.fileExists(atPath: path!) {
                
                do {
                    try FileManager.default.removeItem(atPath: path!)
                } catch {
                    
                }
            }
        }
    }
    
   
    @IBAction func callus(_ sender: Any) {
        
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
