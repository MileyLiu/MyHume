//
//  RoundButton.swift
//  HumeApp
//
//  Created by MileyLiu on 28/9/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit

class RoundButton: UIButton{

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = rect.width/2
        self.layer.masksToBounds = true
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
        
        
    }
    

}
