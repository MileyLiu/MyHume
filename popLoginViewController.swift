//
//  popLoginViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 13/2/18.
//  Copyright © 2018 MileyLiu. All rights reserved.
//

import UIKit

class popLoginViewController: UIViewController {

    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        self.skipButton.layer.cornerRadius = 20
        self.skipButton.layer.borderWidth = 2
        self.skipButton.layer.borderColor = mainColor.cgColor
        self.loginButton.layer.cornerRadius = 20
        self.popView.layer.cornerRadius = 10
        self.showAnimation()

        // Do any additional setup after loading the view.
    }
    @IBAction func loginAction(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let startViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "signinView")
        
        self.present(startViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func skipAction(_ sender: Any) {
//        self.removeAnimation()
        self.dismiss(animated: true, completion: nil)
    }
    
    func showAnimation(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
        
    }
    func removeAnimation(){
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
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
