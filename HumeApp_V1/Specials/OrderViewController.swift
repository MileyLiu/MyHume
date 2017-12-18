//
//  OrderViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 13/10/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import SVProgressHUD
import Alamofire


class OrderViewController: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var accountName: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var contactNumber: UITextField!
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var branchTextField: UITextField!
    @IBOutlet weak var jobTypeText: UITextField!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var submitButton: UIButton!
    var pickedBranch : String = ""
    var pickedjobType :String = ""
    var pickedDate :String = ""
    
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var branchLabel: UILabel!
    
     var itemsInfo :NSMutableArray = NSMutableArray()
    var itemsArray : NSMutableArray = NSMutableArray()
  
    
    var pickerIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = LanguageHelper.getString(key: "ADDITIONA_DETAIL")
        self.accountName.placeholder = LanguageHelper.getString(key: "HUME_ACC")
        self.nameTextField.placeholder = LanguageHelper.getString(key: "YOUR_NAME")
        self.contactNumber.placeholder = LanguageHelper.getString(key: "YOUR_CONTACT")
        
        self.dateTextField.placeholder = LanguageHelper.getString(key: "DATE_REQUIRED")
        self.dateLabel.text = LanguageHelper.getString(key: "DATE_REQUIRED")
       
        self.jobTypeText.placeholder = LanguageHelper.getString(key: "JOB_TYPE")
        self.jobLabel.text = LanguageHelper.getString(key: "JOB_TYPE")
        
        self.branchLabel.text = LanguageHelper.getString(key: "BRANCH")
        
        self.submitButton.setTitle( LanguageHelper.getString(key: "SUBMIT"), for: .normal)

        
        self.branchTextField.delegate = self
        self.jobTypeText.delegate = self
        self.dateTextField.delegate = self
        
        
       
        self.accountName.configKeyboard()
        self.nameTextField.configKeyboard()
        self.contactNumber.configKeyboard()
        
        
       
        
       itemsInfo = ShoppingCar.ShoppingListFromDB()
        
        for array in itemsInfo {
            
            let item = array as! ShoppingCar
            print("item:\(item.id!),\(item.name!),\(item.count)")
            
            
            let newDic = ["itemId":item.id!,"quantity":item.count]
            
            itemsArray.add(newDic)
            
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    

   func pickFromBranch(_ sender: Any) {
        
    
    ActionSheetStringPicker.show(withTitle: "Branches", rows: branches, initialSelection: 1, doneBlock: {
        
        picker, value, index in
        
        
        self.pickedBranch = index as! String
        self.branchTextField.text =  self.pickedBranch
        print("pickedBranch:\(self.pickedBranch)")
        return
        
        
    }, cancel: { ActionStringCancelBlock in return }, origin: sender)
}
   
    func pickFromJob(_ sender: Any) {
        
        
        
        ActionSheetStringPicker.show(withTitle: LanguageHelper.getString(key: "JOB_TYPE"), rows: jobType, initialSelection: 1, doneBlock: {
            
            picker, value, index in
            
            self.pickedjobType = index as! String
            
            self.jobTypeText.text =  self.pickedjobType
            print("jobTypeText:\(String(describing: self.jobTypeText.text))")
            return
            
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
        
        
        
//        switch String(describing: preferredLang) {
//        case "en-US", "en-CN":
//
//            ActionSheetStringPicker.show(withTitle: "Job Type", rows: jobType, initialSelection: 1, doneBlock: {
//
//                picker, value, index in
//
//                self.pickedjobType = index as! String
//
//                self.jobTypeText.text =  self.pickedjobType
//                print("jobTypeText:\(String(describing: self.jobTypeText.text))")
//                return
//
//            }, cancel: { ActionStringCancelBlock in return }, origin: sender)
//
//
//        case "zh-Hans-US","zh-Hans-CN","zh-Hant-CN","zh-TW","zh-HK","zh-Hans":
//
//            ActionSheetStringPicker.show(withTitle: "提货方式", rows: jobTypeCN, initialSelection: 1, doneBlock: {
//
//                picker, value, index in
//
//                self.pickedjobType = index as! String
//
//                self.jobTypeText.text =  self.pickedjobType
//                print("jobTypeText:\(String(describing: self.jobTypeText.text))")
//                return
//
//            }, cancel: { ActionStringCancelBlock in return }, origin: sender)
//
//        default:
//
//            ActionSheetStringPicker.show(withTitle: "Job Type", rows: jobType, initialSelection: 1, doneBlock: {
//
//                picker, value, index in
//
//                self.pickedjobType = index as! String
//
//                self.jobTypeText.text =  self.pickedjobType
//                print("jobTypeText:\(String(describing: self.jobTypeText.text))")
//                return
//
//            }, cancel: { ActionStringCancelBlock in return }, origin: sender)
//        }
    }
    
    func pickFromDate(_ sender: Any) {
        
        ActionSheetDatePicker.show(withTitle:LanguageHelper.getString(key: "DATE"), datePickerMode: UIDatePickerMode.date, selectedDate: Date(), doneBlock: {
            picker, values, indexes in
            let components = Calendar.current.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: (values as! NSDate) as Date)
            self.pickedDate = String(describing: components.day!)+"/"+String(describing: components.month!)+"/"+String(describing: components.year!)
           
            self.dateTextField.text = self.pickedDate
        }, cancel: {
            ActionMultipleStringCancelBlock in
            return
        }, origin: sender as! UIView)
        
       
    }
   

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        if textField.tag == 3 {
              pickFromBranch(textField)
            
        }
        if textField.tag == 2 {
            
            pickFromJob(textField)
        }
        if textField.tag == 1{
            
            pickFromDate(textField)
        }
       
        
        return false
    }

    
    
    @IBAction func submitClicked(_ sender: Any) {
        
        
       
        
        if self.nameTextField?.text?.isEmpty ?? true {
           let emptyAlert = getSimpleAlert(titleString:alertString,messgaeLocizeString:"FILL_ERROR")
            self.present(emptyAlert, animated: true, completion: nil)
            return
        }
        if self.contactNumber?.text?.isEmpty ?? true {
           
            let emptyAlert = getSimpleAlert(titleString:alertString,messgaeLocizeString:"FILL_ERROR")
            self.present(emptyAlert, animated: true, completion: nil)
            return
        }
        if self.contactNumber?.text?.isEmpty ?? true {
            
            let emptyAlert = getSimpleAlert(titleString:alertString,messgaeLocizeString:"FILL_ERROR")
            self.present(emptyAlert, animated: true, completion: nil)
            return
        }
        if self.jobTypeText?.text?.isEmpty ?? true {
            
            let emptyAlert = getSimpleAlert(titleString:alertString,messgaeLocizeString:"FILL_ERROR")
            self.present(emptyAlert, animated: true, completion: nil)
            return
        }
        if self.dateTextField?.text?.isEmpty ?? true {
            
            let emptyAlert = getSimpleAlert(titleString:alertString,messgaeLocizeString:"FILL_ERROR")
            self.present(emptyAlert, animated: true, completion: nil)
            return
        }
        if self.branchTextField?.text?.isEmpty ?? true {
            
            let emptyAlert = getSimpleAlert(titleString:alertString,messgaeLocizeString:"FILL_ERROR")
            self.present(emptyAlert, animated: true, completion: nil)
            return
        }

        let humeName = self.accountName.text
        let userName = self.nameTextField.text
        let contactNumber = self.contactNumber.text
        let comment = "\(self.pickedjobType) at \(self.pickedBranch)  on \(self.pickedDate)"
        
        print("ietms:\(itemsArray.count)")
        
        let url = hostApi+"myHume-rest/order/submit"
        
        let parameters: [String: AnyObject] = [
            "customer" : humeName as AnyObject,
            "name" : userName as AnyObject,
            "phone" : contactNumber as AnyObject,
            "comments" : comment as AnyObject,
            "items" : itemsArray as AnyObject
        ]
        
        print("ORDERpara:\(parameters)")
        
        SVProgressHUD.show()
        
        Alamofire.request(url, method: .post ,parameters: parameters, encoding: JSONEncoding.default, headers:headers).responseJSON {
            response in
            switch response.result{
            case .success(let value):
                
                print("order submitted\(value)")
                
                
              
                sucessfulAlert.addAction(UIAlertAction(title: okString, style: UIAlertActionStyle.default, handler:{
                    action in
                    
                    ShoppingCar.deleteAllItems()
                    
                    self.navigationController?.popToRootViewController(animated: true)
                    
                    
                }))
                
                
                self.present(sucessfulAlert, animated: true, completion: {
                    print("SUBMIT ORDER")
                    
                })
                
            case .failure(let error):
                
                print("Request Error:\(error)")
                
                SVProgressHUD.dismiss()
               
                let networkAlert = getSimpleAlert(titleString: alertString, messgaeLocizeString: "NETWORK_ERROR")
                self.present(networkAlert, animated: true, completion: nil)
                return
            }
            
            
            SVProgressHUD.dismiss()
            
        }
        
        
    }
    
    @IBAction func phone(_ sender: Any) {
        makePhoneCall()
        
    }
    
    
    @IBAction func prioritySupport(_ sender: Any) {
        var controller: PriorityViewController
        
        controller = self.storyboard?.instantiateViewController(withIdentifier: "PriorityViewController") as! PriorityViewController
        
        present(controller, animated: true, completion: nil)
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
