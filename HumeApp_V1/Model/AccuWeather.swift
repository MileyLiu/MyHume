//
//  AccuWeather.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 9/2/18.
//  Copyright © 2018 MileyLiu. All rights reserved.
//

import Foundation
import ObjectMapper
class AccuWeather:Mappable {
    
    var WeatherIcon :Int?
    var TemperatureF :Int?
    var DateTime :String?
    var EpochDateTime :Int?
    var IconPhrase: String?
//    var weather:[WeatherDetail]?
    required init?(map: Map) {
        
    }
    func mapping(map: Map){
        
        WeatherIcon <- map["WeatherIcon"]
        TemperatureF <- map["Temperature.Value"]
        DateTime <- map["DateTime"]
        IconPhrase <- map["IconPhrase"]
        EpochDateTime <- map["EpochDateTime"]
//        weather <- map["weather"]
        
    }
    
}

//class WeatherDetail: Weather {
//    
//    var weatherDes :String?
//    var icon :String?
//    var weatherDetail:String?
//    
//    required init?(map: Map) {
//        super.init(map: map)
//    }
//    
//    override func mapping(map: Map) {
//        super.mapping(map: map)
//        
//        weatherDes <- map["description"]
//        icon <- map["icon"]
//        weatherDetail<-map["weather"]
//    }
//    
//    
//}


