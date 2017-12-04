//
//  ProductCollectionViewCell.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 10/10/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit

// cell的代理方法
protocol ProductCollectionViewCellDelegate : NSObjectProtocol
{
    func collectionViewCellDidClickAddButton(image:UIImage?,centerPoint:CGPoint,button:UIButton)
}



class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addCarButton: UIButton!
    @IBOutlet weak var productImage: UIImageView!
    
    var alreallyAdded : Bool = false
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        titleLabel?.lineBreakMode = .byWordWrapping
//        titleLabel?.numberOfLines = 0
//
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
   
   
   
}
