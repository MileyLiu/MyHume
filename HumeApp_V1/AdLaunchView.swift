//
//  AdLaunchView.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 23/11/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit
import SDWebImage
import DACircularProgress
import SnapKit

@objc protocol AdLaunchViewDelegate: NSObjectProtocol {
    func adLaunchView(launchView: AdLaunchView, bannerImageDidClick imageURL: String)
}

private var sloganHeight: CGFloat = 128

final class AdLaunchView: UIView {
    
    weak var delegate: AdLaunchViewDelegate?
    
    // 启动广告背景
    private lazy var adBackground: UIView = {
        let wid = UIScreen.main.bounds.width
        let hei = UIScreen.main.bounds.height
        
        var footer: UIView = UIView(frame: CGRect(x:0, y:hei - sloganHeight, width:wid, height:sloganHeight))
        footer.backgroundColor = UIColor.white
        
        var slogan: UIImageView = UIImageView(image: UIImage(named: "hume"))
        footer.addSubview(slogan)

        slogan.snp.makeConstraints({ (make) in
            make.center.equalTo(footer)
        })
        
        var view: UIView = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.white
        view.addSubview(footer)
        return view
    }()
    
    // 图片链接
    private var imageURL: String = "http://www.humeplaster.com.au/hume/wp-content/uploads/2017/08/pack_2000-270x250.jpg"
    
    private var imageURLS :[String] = [
//        "http://www.humeplaster.com.au/hume/wp-content/uploads/2017/08/pack_2000-270x250.jpg",
//        "http://www.humeplaster.com.au/hume/wp-content/uploads/2017/06/IMG_4168-copy-FRONT-270x250.png",
//        "http://www.humeplaster.com.au/hume/wp-content/uploads/2017/05/ABCHBASE45-270x250.jpg",
        "http://www.humeplaster.com.au/hume/wp-content/uploads/2016/07/North-Residences-Milsons-Point-2.jpg",
        "http://www.humeplaster.com.au/hume/wp-content/uploads/2016/07/North-Residences-Milsons-Point-1.jpg",
        "http://www.humeplaster.com.au/hume/wp-content/uploads/2016/07/North-Residences-Milsons-Point-3.jpg",
        "http://www.humeplaster.com.au/hume/wp-content/uploads/2016/07/North-Residences-Milsons-Point-4.jpg",
        "http://www.humeplaster.com.au/hume/wp-content/uploads/2017/06/Hume-AAC-Adhesive-product-website.jpg"
    ]
    
    
    private var localImages :[String] = ["launch1","launch2","launch3","launch4"]

    
    // 启动页广告
    private var adImageView: UIImageView?
    
    // 进度条
    private var progressView: DACircularProgressView?
    // 跳过广告按钮
    private var progressButtonView: UIButton?
    
    
    private var randomNumber = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(adBackground)
        
        
        randomNumber = Int(arc4random_uniform(UInt32(1 +  imageURLS.count - 1))) + 0
        // 广告主流程
        displayCachedAd()
        requestBanner()
        showProgressView()
        let delayTime = DispatchTime.now() + 4
        
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.removeFromSuperview()
        }
        
    }
    
    override func removeFromSuperview() {
        UIView.animate(withDuration: 1, animations: {
            self.alpha = 0
        }) { (finished: Bool) in
            super.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - private
private extension AdLaunchView {
    
    func displayCachedAd() {
        let manange: SDWebImageManager = SDWebImageManager()
        if (((manange.imageCache?.imageFromDiskCache(forKey: imageURLS[randomNumber])) == nil)) {
            self.isHidden = true
        } else {
            showImage()
        }
    }
    
    func requestBanner() {
        

        SDWebImageManager.shared().loadImage(with: URL(string:self.imageURLS[randomNumber]) as URL!, options: SDWebImageOptions.continueInBackground, progress: { (receivedSize :Int, ExpectedSize :Int, url : URL) in
            
            } as? SDWebImageDownloaderProgressBlock, completed: { (image : UIImage?, any : Data?,error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                
               print("image downloaded")
                
        })
        
    }
    
    func showImage() {
        adImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - sloganHeight))
        
        if let adImageView = adImageView {
            
            adImageView.sd_setImage(with: NSURL(string: imageURLS[randomNumber]) as! URL)
      
            adImageView.isUserInteractionEnabled = true
            let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AdLaunchView.singleTapAction))
            adImageView.addGestureRecognizer(singleTap)
            
            addSubview(adImageView)
        }
    }
    
    func showProgressView() {
        progressButtonView = UIButton(frame: CGRect(x:UIScreen.main.bounds.width - 60,y: 20,width: 40, height:40))
        if let progressButtonView = progressButtonView {
            progressButtonView.setTitle("跳", for: .normal)
            progressButtonView.tintColor = mainColor
           
            progressButtonView.titleLabel?.textAlignment = .center
            progressButtonView.backgroundColor = UIColor.clear
            progressButtonView.addTarget(self, action: #selector(toHidenState), for: .touchUpInside)
            addSubview(progressButtonView)
        }
        
        progressView = DACircularProgressView(frame: CGRect(x:UIScreen.main.bounds.width - 60,y: 20,width: 40, height:40))
        if let progressView = progressView {
            progressView.isUserInteractionEnabled = false
            progressView.progress = 0
            addSubview(progressView)
            progressView.setProgress(1, animated: true, initialDelay: 0, withDuration: 4)
        }
    }
    
    @objc func singleTapAction() {
        self.delegate?.adLaunchView(launchView: self, bannerImageDidClick: imageURLS[randomNumber])
        toHidenState()
    }
    
    @objc func toHidenState() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (finished: Bool) in
            self.isHidden = true
        }
    }
}

