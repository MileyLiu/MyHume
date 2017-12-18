//
//  ShoppingCarViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 10/10/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit
import SDWebImage

class ShoppingCarViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var clearButton: UIBarButtonItem!
    @IBOutlet weak var shopListTableView: UITableView!
    var dataSource :NSMutableArray = NSMutableArray()
    var listTotalCost: Double = 0.0
    var deletedRowCount = 0
    @IBOutlet weak var listTotalCostLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = LanguageHelper.getString(key: "SHOPPING_CART")
        self.totalLabel.text = LanguageHelper.getString(key: "TOTAL")
        
        self.shopListTableView.delegate = self
        self.shopListTableView.dataSource = self
        
        dataSource = ShoppingCar.ShoppingListFromDB()
        
        calculateTotalCost()
        
        print("ShoppingCarDataSOURCE:\(dataSource.count)")
        
        if dataSource.count == 0 {
            ifShoppingCarExist = false
        }
        
        // Do any additional setup after loading the view.
    }
    
    func calculateTotalCost() {
        
        for data in dataSource{
            
            let tempData = data as! ShoppingCar
            let cost  = ((tempData.count) as NSString).doubleValue * (tempData.priceValue as NSString).doubleValue
            
            listTotalCost  = listTotalCost + cost
            
            print("tempData.count:\(tempData.count)")
            
        }
        
        self.listTotalCostLabel.text = "A$ \(listTotalCost)"
        
        
    }
    
    @IBAction func clearShoppingCart(_ sender: Any) {
       
        let deleteCartAlert = UIAlertController(title: clearString, message: LanguageHelper.getString(key: "DELETE_CHAR"), preferredStyle: UIAlertControllerStyle.alert)
        deleteCartAlert.addAction(UIAlertAction(title: clearString, style: UIAlertActionStyle.default, handler: { action in
            
            // do something like...
            ShoppingCar.deleteAllItems()
            self.dataSource.removeAllObjects()
            self.listTotalCost = 0.0
            self.listTotalCostLabel.text = "A$ \(self.listTotalCost)"
            self.shopListTableView.reloadData()
            
            ifShoppingCarExist = false
            self.clearButton.isEnabled = ifShoppingCarExist
            
        }))
        
        deleteCartAlert.addAction(UIAlertAction(title: cancelString, style: UIAlertActionStyle.cancel, handler: { action in
            
            return
        }))
        self.present(deleteCartAlert, animated: true) {
            
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
       
        if dataSource.count > 0 {
            return 1
            
        }
        else{
            
            TableViewHelper.EmptyMessage(message: LanguageHelper.getString(key: "NO_ITEM"), viewController: tableView)
            
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCarCell") as! ShoppingCarTableViewCell
        
        
        let shoppingCar  = self.dataSource[indexPath.row] as! ShoppingCar
        cell.productTitle.text = shoppingCar.name
        cell.productDesc.text = shoppingCar.spec
        
        cell.productImageURL = shoppingCar.imageUrl!
        cell.id = shoppingCar.id
        
        SDWebImageManager.shared().loadImage(with: URL(string:shoppingCar.imageUrl!) as URL!, options: SDWebImageOptions.continueInBackground, progress: { (receivedSize :Int, ExpectedSize :Int, url : URL) in
            
            } as? SDWebImageDownloaderProgressBlock, completed: { (image : UIImage?, any : Data?,error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                
                cell.productImage.image = image
                
        })
        let itemCount = shoppingCar.count as NSString
        print("itemCount:\(shoppingCar.name):\(itemCount)")
        
        cell.countInt = itemCount.integerValue
        cell.priceDouble = (shoppingCar.priceValue as NSString).doubleValue
        
        cell.countLabel.text = shoppingCar.count
        cell.countLabel.tag = cell.countInt
        
        cell.totalPriceDouble = cell.priceDouble * Double(cell.countInt)
        cell.totalPriceLabel.text = "A$ \(cell.totalPriceDouble)"
        
        cell.cartCellDelegate = self
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return deleteString
    }
    
    //    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    //
    //        self.calculateTotalCost()
    //        return "total Price: A$\(listTotalCost)"
    //    }
    //
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
        let deletePoduct = dataSource[indexPath.row] as! ShoppingCar
        
//        let deleteName = deletePoduct.name
//        
        let deleteprice = (deletePoduct.priceValue as NSString).doubleValue
        let deletcCount = (deletePoduct.count as NSString).doubleValue
        let deleteTotalprice = deleteprice*deletcCount
        
        listTotalCost = listTotalCost-deleteTotalprice
        
        self.listTotalCostLabel.text = "$A \(listTotalCost)"
        
        
        print("deletePoduct.totalPrice:\(deletePoduct.totalPrice)")
        
        
        dataSource .removeObject(at: indexPath.row)
        
        self.shopListTableView.deleteRows(at: [indexPath], with:UITableViewRowAnimation.fade)
        
        ShoppingCar.deleteOneTypeItems(id:deletePoduct.id)
        deletedRowCount = deletedRowCount+1
         print("datasourcecount\(dataSource.count)")
        print("已经删除\(deletedRowCount)条内容")
        
        if(dataSource.count == 0){
         
            self.listTotalCost = 0.0
            self.listTotalCostLabel.text = "A$ \(self.listTotalCost)"
            
            ifShoppingCarExist = false
            self.clearButton.isEnabled = ifShoppingCarExist
           
        }
       
    }
    
    
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
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
extension ShoppingCarViewController: ShoppingCartCellDelegate{
    func reCalculateTotalPrice(price: Double, add: Bool) {
        
        
        if add == true{
            listTotalCost = listTotalCost+price
        }
        else{
            listTotalCost = listTotalCost-price
            
        }
        self.listTotalCostLabel.text = "$A \(listTotalCost)"
    }
    
    
    
    
    //    func reCalculateTotalPrice(){
    //
    //
    ////        dataSource = ShoppingCar.ShoppingListFromDB()
    //
    //        print("new DataSource:\(dataSource)")
    //
    //
    //
    //        calculateTotalCost()
    //    }
    
}
