//
//  Constant.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 29/9/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces

//let APIKey = "AIzaSyCMYbNcnhJZt8WOAUG4G0Uxjfc4qxYS2RI"
let DISAPIKey = "AIzaSyBGZba7luJRSuyarsiyKnVO0yAHw4baZes"
let APIKey = "AIzaSyC8SwxiRuHSdZdomYuOPE1Ac-mrkVmiGi8"
//#a51c3d
let mainColor = UIColor.init(red: 165/255.0, green: 28/255.0, blue: 61/255.0, alpha: 1.0)
let bgColor = UIColor.init(red: 233/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0)
let telString = "tel://134863"

let address = ["149+Mitchell+Road,+Alexandria",
               "6+Frazer+Street,+Lakemba,+NSW",
               "14-16+Suakin+Street,+Pymble,+NSW",
               "9+Blaxland+Street,+Silverwater,+NSW",
               "32+Pine+Road,+Yennora,+NSW",
               "86+Ferndell+Street,+South,+Granville,+NSW",
               "1C+Bell+Street,+Preston,+VIC,+3072",
               "540+Somerville+Road,+Sunshine+West,+VIC,+3020"
]

let placeIdArray = ["ChIJmdalXoCoEmsR5dBXNOt4WPE"]

let waetherAPIKEY = "366edfe1d79d1e4b523002e4da3771d8"

let storePlaces :[GMSPlace] = []

let slipPattern = "[A-Za-z]{2,3}/[0-9]{6}"
let slipMatcher = MyRegex(slipPattern)

let suburbPattern = "[A-Za-z]{3,}"
let suburbMatcher = MyRegex(suburbPattern)


//基本
let alertString =  LanguageHelper.getString(key: "ALERT")
let deleteString = LanguageHelper.getString(key: "DELETE")
let sucessString = LanguageHelper.getString(key: "SUCCESS")
let okString =  LanguageHelper.getString(key: "OK")
let cancelString =  LanguageHelper.getString(key: "CANCEL")
let clearString =  LanguageHelper.getString(key: "CLEAR")
let confirmString =  LanguageHelper.getString(key: "CONFIRM")
let doneString = LanguageHelper.getString(key: "DONE")
let submitString =  LanguageHelper.getString(key: "SUBMIT")

//错误
let subrubErrorString = LanguageHelper.getString(key: "SUBURB_ERRO")
let slipErrorString = LanguageHelper.getString(key: "SLIP_ERROR")
let fillErrorString = LanguageHelper.getString(key: "FILL_ERROR")
let recordErrorString = LanguageHelper.getString(key: "RECORD_ERROR")
let networkErrorString = LanguageHelper.getString(key: "NETWORK_ERROR")
//提示
let deleteHistoryString = LanguageHelper.getString(key: "DELETE_HISTORY")
let deleteCharString = LanguageHelper.getString(key: "DELETE_CHAR")
let submitSucessString = LanguageHelper.getString(key: "SUBMIT_SUCESS")
let noHistoryString = LanguageHelper.getString(key: "NO_HISTORY")
let noItemString = LanguageHelper.getString(key: "NO_ITEM")


let suburbAlert =  UIAlertController(title: alertString, message:  subrubErrorString, preferredStyle: UIAlertControllerStyle.alert)
let slipAlert = UIAlertController(title: alertString, message:slipErrorString, preferredStyle: UIAlertControllerStyle.alert)

  let recordAlert = UIAlertController(title: alertString, message: recordErrorString, preferredStyle: UIAlertControllerStyle.alert)

let sucessfulAlert = UIAlertController(title: sucessString, message: submitSucessString, preferredStyle: UIAlertControllerStyle.alert)


var branches = ["Alexandria Branch","Lakemba Branch","Pymble Branch","Silverwater","Yennora Branch","South Granville Branch","Preston Branch","Sunshine West Branch"]



var jobType = [LanguageHelper.getString(key: "DELIVERY"),LanguageHelper.getString(key: "PICKUP")]
//var jobTypeCN = ["送货","自取"]
var requestType = ["Place an order","Existing Order","General Order","Account enquiry"]
let hostApi = "http://hls.humeplaster.com.au/api"

let user = "admin"
let password = "@humeit"

let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
let base64Credentials = credentialData.base64EncodedString(options: [])
let headers = ["Authorization": "Basic \(base64Credentials)"]


var ifShoppingCarExist : Bool = true
var ifHistoryExist: Bool = true
var ifAllowRealtime: Bool = false

var shoopingCartCount = "0"

let preferredLang = Bundle.main.preferredLocalizations.first! as NSString

let suggestions = ["APP","PRODUCT","OTHER"]
let complaints = ["DELIVERY","GENERAL","PRODUCT"]

let FONT_TITLE_SIZE = Float(20.0)
let FONT_CONTENT_SIZE = Float(16.0)
let FONT_DETAILS_SIZE = Float(14.0)

let deviceModel = UIDevice.current.model

let messageFontSize = CGFloat(14)

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height








