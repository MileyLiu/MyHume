//
//  SideMenuListViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 2/2/18.
//  Copyright © 2018 MileyLiu. All rights reserved.
//

import UIKit
import SafariServices
import FBSDKShareKit
import FBSDKLoginKit
import GoogleSignIn
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI
import FirebaseTwitterAuthUI
import FirebasePhoneAuthUI
import SDWebImage

class SideMenuListViewController: UIViewController,SFSafariViewControllerDelegate,TWTRComposerViewControllerDelegate,FUIAuthDelegate,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var sideMenuTableView: UITableView!
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    
    var cells: ExpendingCell!
    var previouslySelectedHeaderIndex : Int?
    var selectedHeaderIndex :Int?
    var selectedItemIndex : Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.setButtonTitleAsChosenLanguage()
        
        cells = ExpendingCell()
        self.setUpMenu()
        
        self.sideMenuTableView.delegate = self
        self.sideMenuTableView.dataSource = self
        self.sideMenuTableView.estimatedRowHeight = 44.0
        self.sideMenuTableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.sideMenuTableView.reloadData()
    }
    
    func setUpMenu(){
        self.cells.append(ExpendingCell.HeaderItem(value: "Home"))
        self.cells.append(ExpendingCell.HeaderItem(value: "Share"))
        self.cells.append(ExpendingCell.HeaderItem(value: "Setting"))
        self.cells.append(ExpendingCell.Item(value: "Language"))
        self.cells.append(ExpendingCell.Item(value: "Cache"))
        self.cells.append(ExpendingCell.Item(value: "Notification"))
        self.cells.append(ExpendingCell.HeaderItem(value: "Feedback"))
        self.cells.append(ExpendingCell.HeaderItem(value: "Log out"))
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        return UITableViewAutomaticDimension
        
        let item = self.cells.items[(indexPath as NSIndexPath).row]
        
        if item is ExpendingCell.HeaderItem {
            return 60
        } else if (item.isHidden) {
            return 0
        } else {
            return UITableViewAutomaticDimension
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        let item = self.cells.items[(indexPath as NSIndexPath).row]
        
        if item is ExpendingCell.HeaderItem {
            if self.selectedHeaderIndex == nil {
                self.selectedHeaderIndex = (indexPath as NSIndexPath).row
                
            } else {
                
                self.previouslySelectedHeaderIndex = self.selectedHeaderIndex
                self.selectedHeaderIndex = (indexPath as NSIndexPath).row
                
            }
            
            if let previouslySelectedHeaderIndex = self.previouslySelectedHeaderIndex {
                
                self.cells.collapse(previouslySelectedHeaderIndex)
            }
            
            if self.previouslySelectedHeaderIndex != self.selectedHeaderIndex {
                
                self.cells.expand(self.selectedHeaderIndex!)
                
            } else {
                
                self.selectedHeaderIndex = nil
                self.previouslySelectedHeaderIndex = nil
                
                
            }
            //todo fill them
            
            switch indexPath.row{
            case 0:
                print("Home")
                
                
            case 1:
                print("Share")
            case 2:
                print("setting")
            case 6:
                print("feedback")
                
            case 7:
                print("logout")
            default:
                print(indexPath.row)
                
            }
            
            
            
            
            
            
            
            self.sideMenuTableView.beginUpdates()
            self.sideMenuTableView.endUpdates()
            
        } else {
            if (indexPath as NSIndexPath).row != self.selectedItemIndex {
                let cell = self.sideMenuTableView.cellForRow(at: indexPath)
                cell?.accessoryType = UITableViewCellAccessoryType.checkmark
                print("cell 6.0")
                
                if let selectedItemIndex = self.selectedItemIndex {
                    
                    print("cell 7.0")
                    let previousCell = self.sideMenuTableView.cellForRow(at: IndexPath(row: selectedItemIndex, section: 0))
                    previousCell?.accessoryType = UITableViewCellAccessoryType.none
                    cells.items[selectedItemIndex].isChecked = false
                }
                
                self.selectedItemIndex = (indexPath as NSIndexPath).row
                cells.items[self.selectedItemIndex!].isChecked = true
                print("cell 8.0")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cells.items.count
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //1.homeCell
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell")
            cell?.textLabel?.text = LanguageHelper.getString(key: "HOME")
            
            return cell!
        }
        else{
            
            
            
            
            
            
            let item = self.cells.items[(indexPath as NSIndexPath).row]
            let value = item.value
            //        let isChecked = item.isChecked as Bool
            
            
            
            //2.menuCell
            //3.settingCell
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") {
                cell.textLabel?.text = value
                cell.imageView?.image = UIImage(named:value)
                
                if item as? ExpendingCell.HeaderItem != nil {
                    cell.backgroundColor = UIColor.white
                    cell.accessoryType = .none
                } else {
                    //                if isChecked {
                    //                    cell.accessoryType = .checkmark
                    //                } else {
                    //                    cell.accessoryType = .none
                    //                }
                }
                
                return cell
            }
            
            return UITableViewCell()
            
            
        }
    }
}
/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */


