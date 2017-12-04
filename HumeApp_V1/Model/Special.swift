//
//  Special.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 6/10/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import Foundation
import ObjectMapper

class Special:Mappable {
    
    var id :Int?
    var imageLargeUrl :String?
    var imageUrl :String?
    var itemUrl :String?
    var name: String?
    var price: String?
    var priceValue :Double?
    var spec: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map){
       
        id <- map["id"]
        imageLargeUrl <- map["imageLargeUrl"]
        imageUrl <- map["imageUrl"]
        itemUrl <- map["itemUrl"]
        name <- map["name"]
        price <- map["price"]
        priceValue <- map["priceValue"]
        spec <- map["spec"]
     
    }

}

