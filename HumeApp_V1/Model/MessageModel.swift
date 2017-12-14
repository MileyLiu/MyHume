//
//  MessageModel.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 8/12/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import Foundation

enum ComCategory {
    case Delivery
    case General
    case Product
}


class MessageModel: NSObject {
    
  
    var content: String
    var type : ChatType
    var category: String
    var time : String
    
    
    
    init(content:String,type:ChatType,category:String,time:String) {
       
       
        self.content = content
        self.type = type
        self.category = category
        self.time = time
        
    }
    
    func insertIfToDB() ->Bool{
        
        
      
      
        
//        let insertSQL = "INSERT INTO 't_Message' (content,type,category,time) VALUES ('\(content)','\(type)','\(category)','\(time)');"
        
        let insertSQL = "INSERT INTO 't_Message' (content,type,category,time) VALUES ('\(content)','\(type)','\(category)','\(time)');"
        
        print("insertSQLMessage\(insertSQL)")
        
        
        if SQLiteManager.shareInstance().execSQL(SQL: insertSQL) {
            print("插入Messgae数据成功")
          
            return true
        }else{
            
            return false
        }
        
    }
    
    class func MessageFromDB(category:String) -> NSMutableArray {
        
        let dataList = NSMutableArray()
        
        let querySQL = "SELECT content,type,time FROM 't_Message' WHERE category = '\(category)';"
        
        print("querySQL:\(querySQL)")
        //取出数据库中用户表所有数据
        let allMessageDictArr = SQLiteManager.shareInstance().queryDBData(querySQL: querySQL)
        print("allMessageDictArr:\(String(describing: allMessageDictArr))")
        
        //        将字典数组转化为模型数组
        if let tempMessageDictM = allMessageDictArr {
            // 判断数组如果有值,则遍历,并且转成模型对象,放入另外一个数组中
            
            print("tempMessageDictM:\(tempMessageDictM)")
            
            for messagedic in tempMessageDictM {
                print("messagedic:\(messagedic)")
                
                
                let content = messagedic["content"] as! String
                let typeString = messagedic["type"] as! String
                
                print("typeeeee1:\(typeString)")
                
                
                let type :ChatType
                
                if typeString == "mine"{
                    
                    type = ChatType.mine
                }else{
                    type = ChatType.someone
                    
                }
                
                 print("typeeeee2:\(type)")
                
                
                
                let time = messagedic["time"] as! String
                
                
                let oneMessage = MessageModel.init(content:content, type: type, category: category, time: time)
                
                dataList.add(oneMessage)
                
                print("listData0:\(dataList.count)")
                
            }
            //            print("listData1:\(dataList.count)")
            
        }
        //        print("listData2:\(dataList.count)")
        return dataList
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
}




