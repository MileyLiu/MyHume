//
//  Weather.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 21/12/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import Foundation
import ObjectMapper
class Weather:Mappable {
    
    var coord :Double?
    var temperatureK :Double?
    var base :String?
    var wind :Double?
    var id: Int?
    var weather:[WeatherDetail]?
    required init?(map: Map) {
        
    }
    func mapping(map: Map){
        
        coord <- map["coord.lat"]
        temperatureK <- map["main.temp"]
        base <- map["base"]
        wind <- map["wind.speed"]
        id <- map["id"]
        weather <- map["weather"]
        
    }
    
}

class WeatherDetail: Weather {
    
    var weatherDes :String?
    var icon :String?
    var weatherDetail:String?
  
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        weatherDes <- map["description"]
        icon <- map["icon"]
        weatherDetail<-map["weather"]
    }
    
    
}


