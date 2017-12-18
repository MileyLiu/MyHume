//
//  NewHomeViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 19/12/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit

class NewHomeViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var photoGallery = MLPhotoGallery.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-64))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            self.menuButton?.target = self.revealViewController()
            self.menuButton?.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let titleImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        
        titleImageView.image = UIImage(named:"titleLogo")
        titleImageView.contentMode = .scaleAspectFit
        
        self.photoGallery.bindWithLocalPhoto(photoArray: ["morning","afternoon","evening"], interval: 15.0)
        
        self.view.addSubview(photoGallery)
        
        // Do any additional setup after loading the view.
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
