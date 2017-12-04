//
//  IndustryNewsTableViewCell.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 15/11/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit

class IndustryNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var outSourceLabel: UILabel!
    @IBOutlet weak var outTitle: UILabel!
    @IBOutlet weak var outImageView: UIImageView!
    
    var url :String?
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        outTitle.lineBreakMode = .byWordWrapping
        outTitle.numberOfLines = 0
      
        let size = outTitle.sizeThatFits(CGSize(width:outTitle.frame.size.width, height:CGFloat(MAXFLOAT)))
        outTitle.frame = CGRect(x: outTitle.frame.origin.x,y:outTitle.frame.origin.y,width:outTitle.frame.width,height:size.height)
        
        outTitle.font = UIFont.systemFont(ofSize: 18.0 * getMultipler())
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
