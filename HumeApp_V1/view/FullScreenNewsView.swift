//
//  FullScreenNewsView.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 8/2/18.
//  Copyright © 2018 MileyLiu. All rights reserved.
//

import UIKit

class FullScreenNewsView: UIView {
    
    
    var backgroundImage: UIImageView?
    var wordsView : UIView?
    var titleLabel: UILabel?
    var contentLabel: UILabel?
    
    
    var imageURL: String?
    var title: String?
    var content:String?
    
    
    var viewHeight:CGFloat?
    var viewWidth:CGFloat?

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        viewHeight = self.frame.size.height
        viewWidth = self.frame.size.width
    }
    
    required init?(coder aDecoder: NSCoder) {
       
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindWithData(image:String,title:String,content:String){
        
        drawUI()
        
    }
    
    func drawUI(){
        
        backgroundImage = UIImageView.init(frame: CGRect(x:0,y:0,width:viewWidth!,height:viewHeight!))
        
        
        
        
        
        
    }

}
