//
//  StoreAddress.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 29/9/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import Foundation
class StoreAddress: NSObject {
    
    
    var title:String! = nil
    var address: String! = nil
    var latitute: Double! = 0.0
    var longtitute: Double = 0.0
    var placeId :String! = nil
    var phone :String! = "13 4863"
    
    var workday: String = LanguageHelper.getString(key: "WEEKDAY") + " 6.00am - 5.00pm"
    var weekend: String = LanguageHelper.getString(key: "WEEKEND")  + " 6.00am - 3.30pm "
    
    
}
