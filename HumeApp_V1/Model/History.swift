//
//  History.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 5/10/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import Foundation

class History: NSObject {
    
    
    var slipNumber : String?
    var suburb : String?
    var trackingTime: String?
    
    
    init(slipNumber:String, suburb: String, trackingTime:String) {
        self.slipNumber = slipNumber
        self.suburb = suburb
        self.trackingTime = trackingTime
        
    }
    
    init(dict : [String : Any]) {
        super.init()
        self.setValuesForKeys(dict)
    }
    
    //将自身插入数据库接口
    func insertSelfToDB() -> Bool {
        //插入SQL语句
        let insertSQL = "INSERT OR REPLACE INTO 't_History' (slipNumber,suburb,trackingTime) VALUES ('\(slipNumber!)','\(suburb!)','\(trackingTime!)');"
        
        print("insertSQL\(insertSQL)")
        
        
        if SQLiteManager.shareInstance().execSQL(SQL: insertSQL) {
            print("插入self数据成功")
            
            return true
        }else{
            return false
        }
    }
    
    //MARK: - 类方法
    //将本对象在数据库内所有数据全部输出
    
    class func allHistoryFromDB() -> NSMutableArray {
        
        let dataList = NSMutableArray()
    
        let querySQL = "SELECT slipNumber,suburb,trackingTime FROM 't_History' ORDER BY trackingTime DESC"
        //取出数据库中用户表所有数据
        let allHistoryDictArr = SQLiteManager.shareInstance().queryDBData(querySQL: querySQL)
        print("allHistoryDictArr:\(String(describing: allHistoryDictArr))")
        
        //        将字典数组转化为模型数组
        if let tempHistoryDictM = allHistoryDictArr {
            // 判断数组如果有值,则遍历,并且转成模型对象,放入另外一个数组中
            
            print("tempHistoryDictM:\(tempHistoryDictM)")
            
            for historydic in tempHistoryDictM {
                print("historydic:\(historydic)")
                
                
                let time = historydic["trackingTime"] as! String
                let suburb = historydic["suburb"] as! String
                let slipNumber = historydic["slipNumber"] as! String
                
                
                let oneHistory = History.init(slipNumber: slipNumber, suburb: suburb, trackingTime: time)
                
                dataList.add(oneHistory)
                
                print("listData0:\(dataList.count)")
                
            }
//            print("listData1:\(dataList.count)")
            
        }
//        print("listData2:\(dataList.count)")
        return dataList
        
    }
    
    class func deleteAllItems(){
        
        
        let delectAllSQL = "DELETE FROM 't_History'"
        
        let afterDeletingDicArr = SQLiteManager.shareInstance().execSQL(SQL: delectAllSQL)
        
    }
    
   
    
}
