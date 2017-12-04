//
//  LagerImageViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 9/10/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD
class LagerImageViewController: UIViewController {
    
    var lagerUrl:String?
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    //    var imageView: UIImageView?
//    var canclButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
//        self.imageView = UIImageView(frame: CGRect(
//        x: 0, y: 0, width: UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height))
//
//        self.imageView = UIImageView(frame: CGRect(x:0,y:0,width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height))
        
        
        print("larger preview:\(String(describing: self.lagerUrl))")
       
        
        SDWebImageManager.shared().loadImage(with: URL(string:self.lagerUrl!) as URL!, options: SDWebImageOptions.continueInBackground, progress: { (receivedSize :Int, ExpectedSize :Int, url : URL) in
            
            } as? SDWebImageDownloaderProgressBlock, completed: { (image : UIImage?, any : Data?,error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                
                self.imageView?.image = image
                self.imageView?.contentMode = UIViewContentMode.scaleToFill
                SVProgressHUD.dismiss()
        })
        
//        self.view.addSubview(self.imageView!)
        
        
//        self.cancelButton = UIButton(frame: CGRect(x:UIScreen.main.bounds.width - 50,y:30,width:40,height:40))
//
//        self.cancelButton?.titleLabel?.text = "cancel"
//        self.cancelButton?.backgroundColor = mainColor
//        self.cancelButton?.addTarget(self, action: #selector(cancel), for: .touchUpInside)
//
        
     
        
        
//       self.imageView?.addSubview(self.cancelButton!)
        

        // Do any additional setup after loading the view.
    }
   
    @IBAction func cancelCliked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //    @objc func cancel() {
//
//
//    }
    
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
