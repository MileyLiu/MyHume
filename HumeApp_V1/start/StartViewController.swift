//
//  StartViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 8/2/18.
//  Copyright © 2018 MileyLiu. All rights reserved.
//

import UIKit
import QuartzCore

class StartViewController: UIViewController {

    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.continueBtn.layer.cornerRadius = 20
        self.continueBtn.layer.masksToBounds = true
        
        self.signInBtn.layer.cornerRadius = 20
        self.signInBtn.layer.masksToBounds = true
       self.signInBtn.layer.borderColor = UIColor.white.cgColor
        
        
        self.signInBtn.layer.borderWidth = 2
        // Do any additional setup after loading the view.
    }

    @IBAction func GuestClicked(_ sender: Any) {
        
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        //        let initViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "initView") as! ViewController
//        let initViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "initView")
//
//        self.dismiss(animated: true) {
//            self.present(initViewController, animated: true, completion: nil)
//        }
        
        self.dismiss(animated: true, completion: nil)
        
        
        
        
    }
    @IBAction func SignClicked(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                //        let initViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "initView") as! ViewController
        let initViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "signinView")
        
        
        self.present(initViewController, animated: true, completion: nil)
        
        
        
        
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
