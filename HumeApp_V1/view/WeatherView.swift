//
//  WeatherView.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 8/2/18.
//  Copyright © 2018 MileyLiu. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class WeatherView: UIView {

   
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var timeBucketLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var forecastTableView: UITableView!
    
//    var timeBucket: String?//good morning
//    var temperature:String?//19ºC
//    var weatherImageName:String?//03n
//    var BgImageName: String?
    
    var viewHeight:CGFloat?
    var viewWidth:CGFloat?

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        viewHeight = self.frame.size.height
        viewWidth = self.frame.size.width
        
        commonInit()
        //        self.backgroundColor = UIColor.init(patternImage:UIImage(named: "BG")!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func bindWithData(bgImageName:String,timeBucket:String, temperature:String,weatherIamge:String){
       
        self.bgImageView.image = UIImage.gif(name: "rainy")
        self.timeBucketLabel.text = "Good \(timeBucket)"
        self.temperatureLabel.text = temperature
        self.weatherImageView.contentMode = .scaleToFill
        
        self.weatherImageView.image =  UIImage(named:"01d")
        
    }

    private func commonInit(){
        Bundle.main.loadNibNamed("WeatherView", owner: self, options: nil)
        addSubview(contentView)
        
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
