//
//  News.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 6/10/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import Foundation
import ObjectMapper

class News:Mappable {
    
    var content :String?
    var date :String?
    var heading :String?
    var id: Int?
    var imageUrl: String?
    var linkUrl :String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map){
        
        content <- map["content"]
        date <- map["date"]
        heading <- map["heading"]
        id <- map["id"]
        imageUrl <- map["imageUrl"]
        linkUrl <- map["linkUrl"]
       
        
    }
    
}

