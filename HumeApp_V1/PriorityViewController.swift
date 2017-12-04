//
//  PriorityViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 13/10/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class PriorityViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var accountName: UITextField!
    
    @IBOutlet weak var requestTypeTextField: UITextField!
    @IBOutlet weak var contactNumber: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    var requestPicker = UIPickerView()
    var userDefault = UserDefaults.standard
    var pickerIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
     
        if self.revealViewController() != nil {
            self.menuButton?.target = self.revealViewController()
            self.menuButton?.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
//          let networkAlert = getNetworkAlert()
//        networkAlert.addAction(UIAlertAction(title:okString, style: UIAlertActionStyle.default, handler: nil))
        
        self.requestTypeTextField.delegate = self
        

        if let a = userDefault.string(forKey: "humeName"){
            self.accountName.text = a
            
        }
        if let b = userDefault.string(forKey: "userName"){
            self.nameTextField.text = b
        }
        if let c = userDefault.string(forKey: "contactNumber"){
            self.contactNumber.text = c
            
        }
        
    }
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return requestType.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return requestType[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerIndex = row
    }
    //MARK:- TextFiled Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //      self.resignFirstResponder()
       self.pickRequest(textField)
    }
    
    @IBAction func call(_ sender: Any) {
        makePhoneCall()
    }
    
    
    @IBAction func pickRequest(_ textField : UITextField) {
        
        self.requestPicker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.requestPicker.delegate = self
        self.requestPicker.dataSource = self
        self.requestPicker.backgroundColor = UIColor.white
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = mainColor
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: doneString, style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: cancelString, style: .plain, target: self, action: #selector(cancelClick))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        toolBar.isUserInteractionEnabled = true
        textField.inputView = self.requestPicker
        
        textField.inputAccessoryView = toolBar

    }
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        
        if self.requestTypeTextField?.text?.isEmpty ?? true {
            let emptyAlert = getSimpleAlert(titleString:alertString,messgaeLocizeString:"FILL_ERROR")
            self.present(emptyAlert, animated: true, completion: nil)
            return
        }
        
        let humeName = self.accountName.text
        let userName = self.nameTextField.text
        let contactNumber = self.contactNumber.text
        let requestType = requestTypeTextField.text
        
        let url = hostApi+"myHume-rest/order/support"
        

        let parameters: [String: AnyObject] = [
            "account" : humeName as AnyObject,
            "name" : userName as AnyObject,
            "number" : contactNumber as AnyObject,
            "category" : requestType as AnyObject
        ]
        
        print("postpara:\(parameters)")
        
       
      let saveAlert = UIAlertController(title: confirmString, message: LanguageHelper.getString(key: "SAVE_DETAIL"), preferredStyle: UIAlertControllerStyle.alert)
        
        saveAlert.addAction(UIAlertAction(title: okString, style: UIAlertActionStyle.default, handler: { action in
            
            self.userDefault.set(humeName, forKey: "humeName")
            self.userDefault.set(userName, forKey:"userName")
            self.userDefault.set(contactNumber, forKey: "contactNumber")
            self.sendData(url: url, parameters: parameters)

        }))
        
        
        
        saveAlert.addAction(UIAlertAction(title:cancelString,style:UIAlertActionStyle.cancel, handler:{ action in
            
             self.sendData(url: url, parameters: parameters)
            
            
        }))
        
        present(saveAlert, animated: true, completion: nil)
        
    }
    
    func sendData(url:String,parameters:[String:Any]){
         SVProgressHUD.show()
        
        Alamofire.request(url, method: .post ,parameters: parameters, encoding: JSONEncoding.default, headers:headers).responseJSON {
            response in
            switch response.result{
            case .success(_):
                
                let sucessAlert = getSimpleAlert(titleString: sucessString, messgaeLocizeString: "SUBMIT")
                
                self.present(sucessAlert, animated: true, completion: {
                  
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
    
    @objc func doneClick() {
        self.requestTypeTextField.text = requestType[pickerIndex]
        self.requestTypeTextField.resignFirstResponder()
    }
    @objc func cancelClick() {
       self.requestTypeTextField.resignFirstResponder()
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
