//
//  SpecialTableViewCell.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 15/11/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit

@objc protocol SpecialViewCellDelegate: NSObjectProtocol {
    func openDetailPage(productId:Int)
}

class SpecialTableViewCell: UITableViewCell {

    @IBOutlet weak var featuresButton1: UIButton!
    @IBOutlet weak var featuresButton2: UIButton!
    
    @IBOutlet weak var featuresButton3: UIButton!
    
    var specialSource: NSMutableArray = NSMutableArray()
    
    weak var speicalCellDelegate :SpecialViewCellDelegate?
    
//    @IBOutlet weak var ImageView1: UIImageView!
//    @IBOutlet weak var imageView2: UIImageView!
//    @IBOutlet weak var imageView3: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if specialSource.count > 0 {
            
            print("specialcount:\(specialSource.count)")
            
        }
        self.featuresButton1.layer.cornerRadius = 10
        self.featuresButton1.layer.shadowColor = UIColor.black.cgColor
        self.featuresButton1.layer.shadowOffset =  CGSize(width: 5, height: 5)
        self.featuresButton1.layer.shadowRadius =  10
        self.featuresButton1.layer.shadowOpacity = 0.5
        
       
        self.featuresButton2.layer.cornerRadius = 10
        self.featuresButton2.layer.shadowColor = UIColor.black.cgColor
        self.featuresButton2.layer.shadowOffset =  CGSize(width: 5, height: 5)
        self.featuresButton2.layer.shadowRadius =  10
        self.featuresButton2.layer.shadowOpacity = 0.5
        
        
        self.featuresButton3.layer.cornerRadius = 10
        self.featuresButton3.layer.shadowColor = UIColor.black.cgColor
        self.featuresButton3.layer.shadowOffset =  CGSize(width: 5, height: 5)
        self.featuresButton3.layer.shadowRadius =  10
        self.featuresButton3.layer.shadowOpacity = 0.5
 
    }
   
    @IBAction func buttonClicked(_ sender: Any) {
        
    var clickedButton = sender as! UIButton
        
        print("clickedButton:\(clickedButton.tag)")
        
        speicalCellDelegate?.openDetailPage(productId: clickedButton.tag)
 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
