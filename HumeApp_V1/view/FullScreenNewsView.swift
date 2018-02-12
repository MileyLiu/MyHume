//
//  FullScreenNewsView.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 8/2/18.
//  Copyright © 2018 MileyLiu. All rights reserved.
//

import UIKit
import SDWebImage

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
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        viewHeight = self.frame.size.height
        viewWidth = self.frame.size.width
        
        
        //        self.backgroundColor = UIColor.init(patternImage:UIImage(named: "BG")!)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
       
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindWithData(image:String,title:String,content:String){
        
        drawUI()

        titleLabel?.text = title
        contentLabel?.text = content
       
        SDWebImageManager.shared().loadImage(with: URL(string:image) as URL!, options: SDWebImageOptions.continueInBackground, progress: { (receivedSize :Int, ExpectedSize :Int, url : URL) in

            } as? SDWebImageDownloaderProgressBlock, completed: { (image : UIImage?, any : Data?,error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in

                self.backgroundImage?.image = image
                self.backgroundImage?.alpha = 1



        })
    }
    
    func drawUI(){
        
        backgroundImage = UIImageView.init(frame: CGRect(x:0,y:0,width:viewWidth!,height:viewHeight!))
        
        wordsView = UIView.init(frame: CGRect(x:20,y:viewHeight!*0.5,width:viewWidth!-40,height:viewHeight!*0.3))
        
        wordsView?.backgroundColor = UIColor.white
        wordsView?.alpha = 0.8
        
        titleLabel = UILabel.init(frame:CGRect.init(x: 8.0, y:5.0, width: viewWidth!-56, height: viewHeight!*0.1))
        titleLabel?.textColor = mainColor
        titleLabel?.backgroundColor = UIColor.white
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel?.numberOfLines = 0
        titleLabel?.textAlignment = .left
        
        contentLabel = UILabel.init(frame:CGRect.init(x: 8.0, y: viewHeight!*0.1, width: viewWidth!-56, height: viewHeight!*0.15))
        contentLabel?.textColor = UIColor.black
        contentLabel?.backgroundColor = UIColor.white
        contentLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        contentLabel?.textAlignment = .left
        contentLabel?.numberOfLines = 0
        
        wordsView?.addSubview(titleLabel!)
        wordsView?.addSubview(contentLabel!)
        
        self.addSubview(backgroundImage!)
        self.addSubview(wordsView!)
        
    }
    
    

}
