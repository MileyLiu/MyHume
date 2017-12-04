//
//  Tracking.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 5/10/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import Foundation
import ObjectMapper

class Tracking:Mappable {
    
    var expectedDate :String?
    var orderNo :String?
    var schedule :String?
    var status: String?
    var suburb: String?
    var step :Int?
    //timestamps
    
    var confirmed :String?
    var delivered :String?
    var dispatched :String?
    var prepared :String?
    var scheduled: String?
    
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map){
        
        expectedDate <- map["expectedDate"]
        orderNo <- map["orderNo"]
        schedule <- map["schedule"]
        status <- map["status"]
        suburb <- map["suburb"]
        step <- map["step"]
        
        confirmed <- map["timestamps.confirmed"]
        delivered <- map["timestamps.delivered"]
        dispatched <- map["timestamps.dispatched"]
        prepared <- map["timestamps.prepared"]
        scheduled <- map["timestamps.scheduled"]
        
    }
    
}
