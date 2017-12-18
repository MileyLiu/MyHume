//
//  ProductViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 10/10/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SDWebImage
import ObjectMapper
import EAFeatureGuideView


class ProductViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,CAAnimationDelegate{
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    var dataArr = NSMutableArray()//数据源
    var refreshControl: UIRefreshControl?
    let width = UIScreen.main.bounds.size.width//获取屏幕宽
    let height = UIScreen.main.bounds.size.height//获取屏幕高
    var animationView = UIImageView()
    var productNum = "0"
    
    @IBOutlet weak var productNumLabel: UILabel!
    @IBOutlet weak var shoppingCart: UIButton!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        self.navigationItem.title = LanguageHelper.getString(key: "CURRENT_SPECIALS")
        
        self.navigationController?.tabBarItem.title = LanguageHelper.getString(key: "SPECIAL")
       
        if self.revealViewController() != nil {
            self.menuButton?.target = self.revealViewController()
            self.menuButton?.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.productCollectionView.dataSource = self
        self.productCollectionView.delegate = self

        getData()
        createDropdownFresh()
        
        self.shoppingCart.layer.cornerRadius = 25
        
        print("debuging_viewDidLoad:\(shoopingCartCount),\(ifShoppingCarExist)")
        
        if ifShoppingCarExist {
          
            shoopingCartCount =  ShoppingCar.getItemsCount()
        }
        else {
            shoopingCartCount = "0"
        }
     
         self.productNumLabel.text = shoopingCartCount
        
//        showFeatureGuideView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
          super.viewWillAppear(true)
        
        createDropdownFresh()
        
        print("debuging_viewWillAppear:\(shoopingCartCount),\(ifShoppingCarExist)")
        
        if ifShoppingCarExist{
           shoopingCartCount =  ShoppingCar.getItemsCount()
           
        }
        else{
            shoopingCartCount = "0"
        }
     
        self.productNumLabel.text = shoopingCartCount
      
    }

    func showFeatureGuideView(){
        
        let chartItem = EAFeatureItem.init(focus:CGRect(x:width/2-54,y:height/2-46,width:50,height:50), focusCornerRadius: 25, focus: UIEdgeInsets.zero)
        
        chartItem?.introduce = LanguageHelper.getString(key: "CART")
        
        self.navigationController?.view.show(with: [chartItem!], saveKeyName: "chart", inVersion: nil)
        
    }
    
    @objc func refresh(sender:AnyObject) {
        
        dataArr = NSMutableArray()
        self.getData()
        self.refreshControl?.endRefreshing()
        
    }
    func createDropdownFresh() -> Void {
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action:#selector(refresh), for: UIControlEvents.valueChanged)
        self.productCollectionView.addSubview(self.refreshControl!)
        
    }
    @IBAction func callUs(_ sender: Any) {
        makePhoneCall()
    }
    
    @IBAction func question(_ sender: Any) {
        var controller: PriorityViewController
        controller = self.storyboard?.instantiateViewController(withIdentifier: "PriorityViewController") as! PriorityViewController
        present(controller, animated: true, completion: nil)
    }
    
    func getData(){
        
        SVProgressHUD.show()
        let url :String = hostApi + "myHume-rest/special/get"
        
        Alamofire.request(url)
            .validate()
            .responseJSON {response in
                switch response.result {
                case .success(let value):
                    
                    let resultArray = value as! NSArray
                    
                    if resultArray.count == 0 {
                        UIApplication.shared.endIgnoringInteractionEvents()
                        SVProgressHUD.dismiss()
                        return
                    }
                    
                    for index in 0..<resultArray.count{
                        let special = Mapper<Special>().map(JSONObject: resultArray[index])
                        self.dataArr.add(special as Any)
              
                    }
                case .failure(let error):
                    print("Request Error:\(error)")
                    
                    SVProgressHUD.dismiss()
                    
                     let networkAlert = getSimpleAlert(titleString: alertString, messgaeLocizeString: "NETWORK_ERROR")
                    self.present(networkAlert, animated: true, completion: nil)
                    return
                    
                }
                self.productCollectionView?.reloadData()
                SVProgressHUD.dismiss()
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
       return 1
    }
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath as IndexPath) as! ProductCollectionViewCell
        
        let oneSpecial = dataArr[indexPath.row] as! Special
        cell.titleLabel?.text = oneSpecial.name
        
        
        SDWebImageManager.shared().loadImage(with: URL(string:oneSpecial.imageUrl!) as URL!, options: SDWebImageOptions.continueInBackground, progress: { (receivedSize :Int, ExpectedSize :Int, url : URL) in
            
            } as? SDWebImageDownloaderProgressBlock, completed: { (image : UIImage?, any : Data?,error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                
                cell.productImage.image = image
        })
        cell.priceLabel?.text = oneSpecial.price
        
        cell.addCarButton.tag = indexPath.row
        
        cell.productImage.tag = indexPath.row
        cell.productImage.isUserInteractionEnabled = true
        
        cell.layer.cornerRadius = 10
        
        return cell
        
    }
    @IBAction func addToCar(_ sender: Any) {
        
        let button  = sender as! UIButton
        let index = button.tag
        let oneSpecial = dataArr[index] as! Special
        let priceString = String(oneSpecial.priceValue!)
        let idString = String(oneSpecial.id!)
        
        let shoppingCar = ShoppingCar.init(id:idString,name: oneSpecial.name!, imageUrl: oneSpecial.imageUrl!, priceValue: priceString, spec: oneSpecial.spec ?? "")
        
        if shoppingCar.insertSelfToDB(){
            print("insert new item to car")
        }
        
        ////创建动画的imageView
        let window = UIApplication.shared.delegate!.window!
        let rect = button.convert(button.bounds, to: window)
        self.animationView = UIImageView.init(frame: rect)
        self.animationView.image = UIImage(named:"ic_shopping_cart")
        
        print("animation:\(rect)")
        self.view.addSubview(self.animationView)
        self.startAnimation(imageView:self.animationView, button: button)
        
        ifShoppingCarExist = true
        productNum = ShoppingCar.getItemsCount()
        self.productNumLabel.text = productNum
    }
    
    func startAnimation(imageView:UIImageView,button:UIButton)
        
    {
        
        button.isEnabled = false
        //初始化旋转动画
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        //设置属性
        animation.toValue = NSNumber(value: Double.pi * 11)
        animation.duration = 0.5
        animation.isCumulative = true;
        animation.repeatCount = 0;
        //初始化抛物线动画
        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
        let startPoint = imageView.center
        let endPoint = self.shoppingCart.center
        //抛物线的顶点,可以根据需求调整
        let controlPoint = CGPoint(x:width * 0.5,y: startPoint.y - 100)
        //生成路徑
        let path = CGMutablePath()
        
        //描述路徑
        path.move(to:startPoint)
        path.addQuadCurve(to: endPoint, control: controlPoint)
        //设置属性
        pathAnimation.duration = 0.5
        pathAnimation.path = path
        //初始化动画组
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [animation,pathAnimation]
        animationGroup.duration = 0.5
        animationGroup.delegate = self
      
        //       延时的目的是让view先做UIView动画然后再做layer动画
        

//        let xSeconds = 1.0
//        DispatchQueue.main.asyncAfter(deadline: .now() + xSeconds) {
//            print("Delayed by 1 Seconds")
//             imageView.layer.add(animationGroup, forKey: nil)
//        }
//
//
        UIView.animate(withDuration: 0.5, animations: {
//            imageView.bounds = CGRect(x:0, y:0, width:20, height:20)
//            imageView.center = endPoint
            imageView.bounds = CGRect(x:0, y:0, width:20, height:20)
            imageView.center = endPoint
            imageView.layer.add(animationGroup, forKey: nil)
        }) { (_) in
             button.isEnabled = true
        }
      
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        //移除动画imageView
        self.animationView.removeFromSuperview()
       
        
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
