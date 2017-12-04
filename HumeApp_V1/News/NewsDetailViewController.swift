//
//  NewsDetailViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 6/10/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class NewsDetailViewController: UIViewController,WKNavigationDelegate {
    
    
    var testURL: String?
    
      var scrollView : UIScrollView!
    
    
    @IBOutlet weak var newsWebView: WKWebView!
    @IBOutlet weak var webScrollView: UIScrollView!
    var viewWidth : CGFloat!
    var viewHeight : CGFloat!
    var webView : WKWebView!
    @IBOutlet var containerView : UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let url = NSURL(string:testURL!)
        let req = URLRequest(url:url! as URL)
        self.webView!.load(req)
        
       
//        setScrollView()
        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        super.loadView()
       
        self.webView = WKWebView()
        self.view = self.webView
    }
    
    func setWebView() {
        // 发送网络请求
//        let url:NSURL = NSURL(string:testURL)!
//        let request:NSURLRequest = NSURLRequest(URL:url as URL)
//        self.newsWebView.load(request as URLRequest)
//        
        // 设置UIWebView接收的数据是否可以通过手势来调整页面内容大小
//        self.newsWebView.scalesPageToFit = true
        
        // 设置UIWebView的代理对象
//        self.newsWebView.delegate = self
    }
    
  
    func setScrollView() {
        
        scrollView = UIScrollView(frame: CGRect(x: CGFloat(0), y: 0, width: CGFloat(viewWidth), height: CGFloat(viewHeight)))
        scrollView.backgroundColor = UIColor.clear
        self.view.addSubview(scrollView)
//        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //        insertCSSString(into: webView) // 1
        
        print("enter")
       
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
