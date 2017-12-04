//
//  ShoppingCarTableViewCell.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 10/10/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit
@objc protocol ShoppingCartCellDelegate{
    func reCalculateTotalPrice(price:Double,add:Bool)
}
class ShoppingCarTableViewCell: UITableViewCell{
   
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productDesc: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    var totalPriceString: String = ""
    var totalPriceDouble :Double = 0.0
    var priceDouble: Double = 0.0
    var countInt: Int = 0
    var productImageURL: String!
    var id : String!
    
    weak var cartCellDelegate:ShoppingCartCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    @IBAction func addClicked(_ sender: Any) {
        
        
        self.countLabel.tag = self.countLabel.tag+1
        self.countLabel.text = String(self.countLabel.tag)
        countInt = self.countLabel.tag
        totalPriceDouble = priceDouble * Double(countInt)
        self.totalPriceLabel.text = "A$ \(totalPriceDouble)"
        
        
        
        let shoppingCar = ShoppingCar.init(id:id,name: productTitle.text!, imageUrl: productImageURL, priceValue: String(priceDouble), spec:productDesc.text! )
        
        if shoppingCar.insertSelfToDB(){
            
            print(" updtae database")
            
        
          
           cartCellDelegate?.reCalculateTotalPrice(price: priceDouble,add: true)
            
//            ShoppingCartCellDelegate.reCalculateTotalPrice(self as! ShoppingCartCellDelegate)

        }
       
       
        
    }
    
    
  
    
    @IBAction func minusClicked(_ sender: Any) {
        
        
        if countLabel.tag > 1{
            
            self.countLabel.tag = self.countLabel.tag-1
            self.countLabel.text = String(self.countLabel.tag)
          
            countInt = self.countLabel.tag
            totalPriceDouble = priceDouble * Double(countInt)
            self.totalPriceLabel.text = "A$ \(totalPriceDouble)"
            
           ShoppingCar.deleteOneItem(id: self.id)
           
//            ShoppingCartCellDelegate.reCalculateTotalPrice(self as! ShoppingCartCellDelegate)
            cartCellDelegate?.reCalculateTotalPrice(price: priceDouble,add:false)
        }
        
        
        
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        // Configure the view for the selected state
    }
    
}
