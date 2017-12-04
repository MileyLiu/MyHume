//
//  NewsTableViewCell.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 29/9/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit
//import FBSDKShareKit
@objc protocol NewsCellDelegate{
    func shareToSocialMedia(title:String,url:URL,image:UIImage)
}
class NewsTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var picImageView: UIImageView!
   
    
    var url: String!
    weak var newsCellDelegate:NewsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    titleLabel.layer.cornerRadius = 5
    
    }
    @IBAction func shareClicked(_ sender: Any) {
        
        print("link:\(self.url)")
        
        
        let title = titleLabel.text!
      
        let url = URL(string:self.url)
        
        let image = picImageView.image
        
        newsCellDelegate?.shareToSocialMedia(title: title, url: url!,image: image!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
