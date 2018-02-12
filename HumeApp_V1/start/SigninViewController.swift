//
//  SigninViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 8/2/18.
//  Copyright © 2018 MileyLiu. All rights reserved.
//

import UIKit

class SigninViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    
    @IBOutlet weak var googleButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.goButton.layer.cornerRadius = 20
        self.goButton.layer.masksToBounds = true
        
        self.emailTextfield.borderStyle = .roundedRect
        self.passwordTextField.borderStyle = .roundedRect
        
        self.facebookButton.set(anImage: UIImage(named:"facebook"), title: "Signin with facebook", titlePosition: .right, additionalSpacing: 5, state: .normal)
        
        self.facebookButton.layer.cornerRadius = 20
        
         self.twitterButton.set(anImage: UIImage(named:"twitter"), title: "Signin with Twitter", titlePosition: .right, additionalSpacing: 5, state: .normal)
        
        self.twitterButton.layer.cornerRadius = 20
         self.googleButton.set(anImage: UIImage(named:"google_plus"), title: "Signin with Google plus", titlePosition: .right, additionalSpacing: 5, state: .normal)
        self.googleButton.layer.cornerRadius = 20
        self.googleButton.layer.borderColor = mainColor.cgColor
        self.googleButton.layer.borderWidth = 2
        
        self.phoneButton.layer.cornerRadius = 20
         self.phoneButton.set(anImage: UIImage(named:"ic_phone_white"), title: "Signin with Phone", titlePosition: .right, additionalSpacing: 5, state: .normal)
        
        
        
    }

    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
