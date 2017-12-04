//
//  RealTime.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 27/10/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import Foundation
import ObjectMapper

class RealTime:Mappable {
    
    var bearing :String?
    var driverId :String?
    var id :String?
    var latitude: Double?
    var longitude: Double?
    var speed :Int?
    var timestamp : String?

    required init?(map: Map) {
        
    }
    func mapping(map: Map){
        
        bearing <- map["bearing"]
        driverId <- map["driverId"]
        id <- map["id"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        speed <- map["speed"]
        timestamp <- map["timestamp"]
        
    }
    
}

