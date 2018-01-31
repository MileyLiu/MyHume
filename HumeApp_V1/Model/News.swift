//
//  News.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 6/10/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import Foundation
import ObjectMapper


//"id": 1,
//"title": "[Trading Hours Changes] Australia Day 2018",
//"content": "All of our stores will be closed on Friday 26th  January for the Australia Day Celebrations and will resume normal business hours on Saturday 27th  January.",
//"titleCn": "[营业时间调整] 2018“澳大利亚日”",
//"contentCn": "澳饰建材旗下所有分店将于1月26日星期五“澳大利亚日”歇业一天，并于次日1月27日星期六恢复正常营业。",
//"date": "2018-01-19",
//"imgSrc": "https://firebasestorage.googleapis.com/v0/b/my-hume.appspot.com/o/images%2F406eb065-7f10-4800-81b5-6b4d637741ac.png?alt=media&token=f72f8559-6fc5-4617-8dc6-e7bd7e1ea5ca",
//"thumbnailSrc": "https://firebasestorage.googleapis.com/v0/b/my-hume.appspot.com/o/images%2F406eb065-7f10-4800-81b5-6b4d637741ac.png?alt=media&token=f72f8559-6fc5-4617-8dc6-e7bd7e1ea5ca",
//"link": "http://www.humeplaster.com.au/news/trading-hours-changes-australia-day-2018/",
//"type": 0

class News:Mappable {
    
    var id: Int?
    var title :String?
    var content :String?
    var titleCn :String?
    var contentCn:String?
    var date :String?
    var imgSrc: String?
    var thumbnailSrc: String?
    var link :String?
    var type: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map){
        
        id <- map["id"]
        title <- map["title"]
        content <- map["content"]
        titleCn <- map["titleCn"]
        contentCn <- map["contentCn"]
        date <- map["date"]
        imgSrc <- map["imgSrc"]
        thumbnailSrc <- map["thumbnailSrc"]
        link <- map["link"]
        type <- map["type"]
       
        
    }
    
}

