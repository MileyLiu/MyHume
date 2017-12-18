//
//  ProductDetailViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 17/11/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit
import SDWebImage

class ProductDetailViewController: UIViewController {
    
    var specialIndex = 0
    var specialDetail: Any?
    
    @IBOutlet weak var spcialLargeImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var desTextView: UITextView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addShoppingCart: UIButton!
    @IBOutlet weak var detailView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let special = specialDetail as! Special
        self.titleLabel.text = special.name
        self.spcialLargeImage.sd_setImage(with: URL(string:special.imageLargeUrl!), completed: nil)
        self.priceLabel.text = "A\(special.price!)"
        self.addShoppingCart.set(anImage: UIImage(named:"ic_shopping_cart_white"), title: LanguageHelper.getString(key: "ADD_SHOPPINGCART"), titlePosition: .right, additionalSpacing: 5, state: .normal)
   
        self.detailView.layer.cornerRadius = 10
        self.detailView.layer.shadowColor = UIColor.black.cgColor
        self.detailView.layer.shadowOffset =  CGSize(width: 5, height: 5)
        self.detailView.layer.shadowRadius =  10
        self.detailView.layer.shadowOpacity = 0.5
        //默认为0
        // view.shadowPath = UIBezierPath(rect: view.bounds).CGPath
        
        var maskPath = UIBezierPath.init(roundedRect: self.addShoppingCart.bounds, byRoundingCorners:[.bottomRight,.bottomLeft], cornerRadii: CGSize(width:5,height:5))
        
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = self.addShoppingCart.bounds
        maskLayer.path = maskPath.cgPath
        self.addShoppingCart.layer.mask = maskLayer
    }
    
    @IBAction func addToChart(_ sender: Any) {
       
        let special = specialDetail as! Special
        let priceString = String(special.priceValue!)
        let idString = String(special.id!)
        
        let shoppingCar = ShoppingCar.init(id:idString,name: special.name!, imageUrl: special.imageUrl!, priceValue: priceString, spec: special.spec ?? "")
        
        if shoppingCar.insertSelfToDB(){
            print("insert new item to car")
        }
        
        
    }
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var backButton: UIButton!
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
