//
//  SliderNewsTableViewCell.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 19/12/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit

@objc protocol slideNewsCellDelegate{
    func shareToSocialMedia(title:String,url:URL,image:UIImage)
}

class SliderNewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var newsImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var url: String!
    weak var slideNewsCellDelegate:slideNewsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
