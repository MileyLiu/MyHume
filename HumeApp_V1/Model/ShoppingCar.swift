//
//  ShoppingCar.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 10/10/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import Foundation
class ShoppingCar :NSObject {
    
    var id :String!
    var name : String!
    var imageUrl :String!
    var priceValue : String!
    var spec :String!
    var count: String = "0"
    var totalPrice:Double = 0.0
    var alreadyAddShoppingCart: Bool = false
    
    
    init(id:String ,name:String, imageUrl:String, priceValue: String ,spec:String){
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.priceValue = priceValue
        self.spec = spec
        
        self.alreadyAddShoppingCart = true
        
    }
    init(id:String,name:String, imageUrl:String, priceValue: String ,spec:String,count:String){
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.priceValue = priceValue
        self.spec = spec
        self.count = count
        self.alreadyAddShoppingCart = true
        
    }
    
    
    // 防止对象属性和kvc时的dict的key不匹配而崩溃
    func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    //    /将自身插入数据库接口
    func insertSelfToDB() -> Bool {
        //插入SQL语句
        
        let insertSQL = "INSERT INTO 't_ShoppingCar' (id,name,imageUrl,priceValue,spec) VALUES ('\(id!)','\(name!)','\(imageUrl!)','\(priceValue!)','\(spec!)');"
        
        print("insertSQLshopping\(insertSQL)")
        
        
        if SQLiteManager.shareInstance().execSQL(SQL: insertSQL) {
            print("插入shopping数据成功")
            alreadyAddShoppingCart = true
            return true
        }else{
            
            return false
        }
    }
    
    class func getItemsCount() ->String{
        
        var count = "0"
        let countSQL = "SELECT count(*) FROM 't_ShoppingCar'"
        
        print("countSQL\(countSQL)")
        
        if SQLiteManager.shareInstance().queryDBData(querySQL: countSQL) != nil{
            
            let countresult = SQLiteManager.shareInstance().queryDBData(querySQL: countSQL)
            
            if let array = countresult{
                let item = array[0]
                if let num = item["count(*)"]{
                    
                    count = num as! String
                    print("countresult2:\(count)")
                    
                }
            }
        }
        else {
            print("countSQL,NOTING BACK")
            
        }
        return count
    }
    
    
   
    
    class func deleteOneItem(id:String!){
        
        print("deleteOneItem.name:\(id)")
        let delectOneSQL = "DELETE FROM 't_ShoppingCar' WHERE id = '\(id!)' LIMIT 1 "
        
        print("deleteOneItem.delectOneSQL:\(delectOneSQL)")
        let afterDeletingDicArr = SQLiteManager.shareInstance().execSQL(SQL: delectOneSQL)
        
        print("afterDeletingDicArr:\(afterDeletingDicArr)")
        
    }
    
    class func deleteAllItems(){
        
        
        let delectAllSQL = "DELETE FROM 't_ShoppingCar'"
        
        let afterDeletingDicArr = SQLiteManager.shareInstance().execSQL(SQL: delectAllSQL)
        
        print("afterDeletingAllDicArr:\(afterDeletingDicArr)")
        
    }
    
    class func deleteOneTypeItems(id:String!){
        
        print("deleteOneItem.id:\(id)")
        
        let delectOneTypeSQL = "DELETE FROM 't_ShoppingCar' WHERE id = '\(id!)'"
        
        print("deleteOneTypeItem.delectOneSQL:\(delectOneTypeSQL)")
        let afterDeletingDicArr = SQLiteManager.shareInstance().execSQL(SQL: delectOneTypeSQL)
        
        print("afterDeletingOnetYPEDicArr:\(afterDeletingDicArr)")
        
    }
    
    class func ShoppingListFromDB() -> NSMutableArray {
        
        
        let dataList = NSMutableArray()
        //        var shopingList = [ShoppingCar]()
        
        let querySQL = "SELECT id,name,imageUrl,priceValue,spec,count(*) FROM 't_ShoppingCar' GROUP BY id"
        //取出数据库中用户表所有数据
        let allShoppingDictArr = SQLiteManager.shareInstance().queryDBData(querySQL: querySQL)
        print("allShoppingDictArr:\(String(describing: allShoppingDictArr))")
        
        //        将字典数组转化为模型数组
        if let tempShoppingDictM = allShoppingDictArr {
            // 判断数组如果有值,则遍历,并且转成模型对象,放入另外一个数组中
            
            print("tempShoppingDictM:\(tempShoppingDictM)")
            
            for shoppingdic in tempShoppingDictM {
                print("shoppingdic:\(shoppingdic)")
                
                let id = shoppingdic["id"] as! String
                let name = shoppingdic["name"] as! String
                let imageUrl = shoppingdic["imageUrl"] as! String
                let priceValue = shoppingdic["priceValue"] as! String
                let spec = shoppingdic["spec"] as! String
                
                let count = shoppingdic["count(*)"] as! String
                
                let oneShopping = ShoppingCar.init(id:id,name: name, imageUrl: imageUrl, priceValue: priceValue, spec: spec,count:count)
                
                dataList.add(oneShopping)
                
                print("listData0:\(dataList.count)")
                
            }
            print("listData1:\(dataList.count)")
            //            return dataList
        }
        print("listData2:\(dataList.count)")
        return dataList
        
    }
    
    
}

