//
//  KeybaordTextField.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 15/12/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit


extension UITextField{
    
    

    
    func configKeyboard() {
        
//        self.delegate = self
    
        self.tintColor = mainColor
      
        
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
    
        
        self.inputAccessoryView = toolBar

    
    }
    @objc func doneClick() {
//        self.requestTypeTextField.text = requestType[pickerIndex]
        
        self.resignFirstResponder()
    }
    @objc func cancelClick() {
        self.text = ""
        self.resignFirstResponder()
    }
    
    
   
    
    
}
