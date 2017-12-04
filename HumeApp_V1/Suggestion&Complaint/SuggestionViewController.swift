//
//  SuggestionViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 10/11/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit

class SuggestionViewController: UIViewController {

    @IBOutlet weak var describeLabel: UILabel!
    
    @IBOutlet weak var describeTextView: UITextView!
    @IBOutlet weak var contactLabel: UILabel!
    
    @IBOutlet weak var contaxtTextField: UITextField!
    var titleString: String?

    @IBOutlet weak var submitButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = titleString
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: UIBarButtonItemStyle.plain,
            target: nil,
            action: nil)
        
        self.submitButton.setTitle(submitString, for: .normal)
        
        
        self.describeLabel.text = LanguageHelper.getString(key: "DESCRIBE")
        self.describeTextView.text = LanguageHelper.getString(key: "DESCRIBE_PH")
        self.contactLabel.text = LanguageHelper.getString(key: "CONTACT")
        self.contaxtTextField.placeholder = LanguageHelper.getString(key: "CONTACT_PH")
        
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
