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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.goButton.layer.cornerRadius = 20
        self.goButton.layer.masksToBounds = true
        
        self.emailTextfield.borderStyle = .roundedRect
        self.passwordTextField.borderStyle = .roundedRect

        // Do any additional setup after loading the view.
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
