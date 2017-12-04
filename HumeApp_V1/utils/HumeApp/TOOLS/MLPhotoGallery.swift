//
//  MLPhotoGallery.swift
//  AlphaNanny_Demo
//
//  Created by Simeng Liu on 25/08/2017.
//  Copyright © 2017 Simeng Liu. All rights reserved.
//

import UIKit

class MLPhotoGallery: UIView, UIScrollViewDelegate {
    
    var photoGallery : UIView = UIView()
    
    
    var timer: Timer?
    var interval:TimeInterval?
    
    var topScroll: UIScrollView?
    var pageControl: UIPageControl?
    
    var galleryHeight:CGFloat?
    var galleryWidth: CGFloat?
    
    var photoCount: Int?
    var photoArray: [String]?
    
    var showFullImage : Bool?
    var tempArray: NSMutableArray = []
    
    var navigationController:UINavigationController?
    
    var imageShow: UIViewController?
    var openImageView: UIImageView?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        galleryHeight = self.frame.size.height
        galleryWidth = self.frame.size.width
        
        
//        self.backgroundColor = UIColor.init(patternImage:UIImage(named: "BG")!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindWithLocalPhoto(photoArray:[String], interval: TimeInterval){
        
        self.photoArray = photoArray
        self.interval = interval
        
        drawUI()
        
        for i in 0...photoArray.count-1{
            
            let imageView = UIImageView.init(frame: CGRect(x:CGFloat(i) * galleryWidth!,y:0, width:galleryWidth!,height:galleryHeight!))
            imageView.contentMode = UIViewContentMode.scaleToFill
            imageView.image = UIImage(named:photoArray[i])
            self.topScroll?.addSubview(imageView)
            imageView.tag = i
            
            print("imageTag:\(i)")
            
        }
        addTimer()
        
    }
    
    func addTimer(){
        if interval != 0 && photoCount! > 1 {
            
            timer = Timer.scheduledTimer(timeInterval: interval!, target: self, selector: #selector(nextStep), userInfo: nil, repeats: true)
            
            RunLoop.current.add(timer!, forMode: .commonModes)
            
        }
        
    }
    
    @objc func nextStep(){
        
        var page = 0
        
        if (self.pageControl?.currentPage == (self.photoCount!-1)) {
            page = 0
        } else {
            page = (self.pageControl?.currentPage)! + 1
        }
        
        let offsetX = CGFloat(page) * (self.topScroll?.frame.size.width)!
        
        let offset = CGPoint(x:offsetX,y:0)
        
        self.topScroll?.setContentOffset(offset, animated: true)
        
    }
    
    func removeTimer(){
        
        timer?.invalidate()
        timer = nil
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let page = Int((scrollView.contentOffset.x + galleryWidth! * CGFloat(0.5)) / galleryWidth!);
        pageControl?.currentPage = page;
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.removeTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        self.addTimer()
    }
    
    
    func drawUI(){
        
        
        showFullImage = false
        photoCount = self.photoArray?.count
        
        
        topScroll = UIScrollView.init(frame: CGRect(x:0,y:0,width:galleryWidth!,height:galleryHeight!))
        
        pageControl = UIPageControl.init(frame: CGRect(x:galleryWidth!*0.4, y:galleryHeight!*0.9, width:galleryWidth!*0.2, height:galleryHeight!*0.1))
        
        
        topScroll?.showsHorizontalScrollIndicator = false;
        topScroll?.isPagingEnabled = true;
        
        
        pageControl?.numberOfPages = photoCount!;
        
        pageControl?.pageIndicatorTintColor = UIColor.white
        pageControl?.currentPageIndicatorTintColor = UIColor.darkGray
        
        
        topScroll?.contentSize = CGSize.init(width: CGFloat(photoCount!) * galleryWidth!, height: 0)
        
        topScroll?.delegate = self
        
        self.addSubview(topScroll!)
        self.addSubview(pageControl!)
        
        
    }
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
