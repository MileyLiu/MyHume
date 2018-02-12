//
//  WeatherTableViewCell.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 9/2/18.
//  Copyright © 2018 MileyLiu. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var tempLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
