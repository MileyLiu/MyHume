//
//  tools.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 3/10/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import Foundation
import UIKit

func makePhoneCall(){
    
    if let url = URL(string:telString){
        
        //根据iOS系统版本，分别处理
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:],
                                      completionHandler: {
                                        (success) in
            })
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
}
func checkState(slip:String)->String{
    
    let array = slip.characters.split(separator: "/")
    
    if (array[0].elementsEqual("PRE")||array[0].elementsEqual("SUN")){
        
        return "VIC"
    }
    else {
        return "NSW"
    }
    
}
func getCurrentTimeString()->String{
    let currentDateTime = Date()
    
    // initialize the date formatter and set the style
    let formatter = DateFormatter()
    formatter.timeStyle = .medium
    formatter.dateStyle = .long
    let currentTime = formatter.string(from: currentDateTime)
    return currentTime
    
}
func formatingSuburb(suburb:String)->String{
    let whiteSpace = NSCharacterSet.whitespacesAndNewlines
    let suburbSent = suburb.trimmingCharacters(in: whiteSpace).replacingOccurrences(of: " ", with: "%20")
    return suburbSent
}

func getSimpleAlert (titleString: String, messgaeLocizeString:String) ->UIAlertController{
    let alert =  UIAlertController(title: titleString, message: LanguageHelper.getString(key: messgaeLocizeString), preferredStyle: UIAlertControllerStyle.alert)
    
    alert.addAction(UIAlertAction(title: okString, style: UIAlertActionStyle.default, handler: nil))
    return alert
}

func toolbarSetting() ->UIToolbar{
    // ToolBar
    let toolBar = UIToolbar()
    toolBar.barStyle = .default
    toolBar.isTranslucent = true
    toolBar.tintColor = mainColor
    toolBar.sizeToFit()
    
    return toolBar
    
}



//func checkSlip(inputString:String){
//    
//  
//    
//    if (matcher.match(input: inputString)){
//        print("correct format")
//        
//    }
//    else {
//        
//        print("incorrect ")
//    }
//    
//    
//}
//正则匹配类工具
struct MyRegex {
    
    let regex: NSRegularExpression?
    
    init(_ pattern: String) {
        regex = try? NSRegularExpression(pattern: pattern,
                                         options: .caseInsensitive)
    }
    
    func match(input: String) -> Bool {
        if let matches = regex?.matches(in: input,
                                                options: [],
                                                range: NSMakeRange(0, (input as NSString).length)) {
            return matches.count > 0
        } else {
            return false
        }
    }
}


//date formatted
func changeUTCtoDate(UTCString:Int) -> String{
    let sunStr = NSString(format: "%d", UTCString)
    let timer:TimeInterval = sunStr.doubleValue
    let data = NSDate(timeIntervalSince1970: timer)
    
    let formatter = DateFormatter()
    formatter.dateStyle = DateFormatter.Style.short
    formatter.dateFormat = "dd/MM"
    let str:String = formatter.string(from: data as Date)
    return str
}

func replaceBlank(origin: String){

    
}
func calculateTimeInterval(previoudTime:Date) -> Double{
    
    
   let interval = Date().timeIntervalSince(previoudTime)
    
    let duration = Double(interval)

    return duration
    
}


func iphoneType() ->String {
    
    var systemInfo = utsname()
    uname(&systemInfo)
    
    let platform = withUnsafePointer(to: &systemInfo.machine.0) { ptr in
        return String(cString: ptr)
    }
    
    if platform == "iPhone1,1" { return "iPhone 2G"}
    if platform == "iPhone1,2" { return "iPhone 3G"}
    if platform == "iPhone2,1" { return "iPhone 3GS"}
    if platform == "iPhone3,1" { return "iPhone 4"}
    if platform == "iPhone3,2" { return "iPhone 4"}
    if platform == "iPhone3,3" { return "iPhone 4"}
    if platform == "iPhone4,1" { return "iPhone 4S"}
    if platform == "iPhone5,1" { return "iPhone 5"}
    if platform == "iPhone5,2" { return "iPhone 5"}
    if platform == "iPhone5,3" { return "iPhone 5C"}
    if platform == "iPhone5,4" { return "iPhone 5C"}
    if platform == "iPhone6,1" { return "iPhone 5S"}
    if platform == "iPhone6,2" { return "iPhone 5S"}
    if platform == "iPhone7,1" { return "iPhone 6 Plus"}
    if platform == "iPhone7,2" { return "iPhone 6"}
    if platform == "iPhone8,1" { return "iPhone 6S"}
    if platform == "iPhone8,2" { return "iPhone 6S Plus"}
    if platform == "iPhone8,4" { return "iPhone SE"}
    if platform == "iPhone9,1" { return "iPhone 7"}
    if platform == "iPhone9,2" { return "iPhone 7 Plus"}
    if platform == "iPhone10,1" { return "iPhone 8"}
    if platform == "iPhone10,2" { return "iPhone 8 Plus"}
    if platform == "iPhone10,3" { return "iPhone X"}
    if platform == "iPhone10,4" { return "iPhone 8"}
    if platform == "iPhone10,5" { return "iPhone 8 Plus"}
    if platform == "iPhone10,6" { return "iPhone X"}
    
    if platform == "iPod1,1" { return "iPod Touch 1G"}
    if platform == "iPod2,1" { return "iPod Touch 2G"}
    if platform == "iPod3,1" { return "iPod Touch 3G"}
    if platform == "iPod4,1" { return "iPod Touch 4G"}
    if platform == "iPod5,1" { return "iPod Touch 5G"}
    
    if platform == "iPad1,1" { return "iPad 1"}
    if platform == "iPad2,1" { return "iPad 2"}
    if platform == "iPad2,2" { return "iPad 2"}
    if platform == "iPad2,3" { return "iPad 2"}
    if platform == "iPad2,4" { return "iPad 2"}
    if platform == "iPad2,5" { return "iPad Mini 1"}
    if platform == "iPad2,6" { return "iPad Mini 1"}
    if platform == "iPad2,7" { return "iPad Mini 1"}
    if platform == "iPad3,1" { return "iPad 3"}
    if platform == "iPad3,2" { return "iPad 3"}
    if platform == "iPad3,3" { return "iPad 3"}
    if platform == "iPad3,4" { return "iPad 4"}
    if platform == "iPad3,5" { return "iPad 4"}
    if platform == "iPad3,6" { return "iPad 4"}
    if platform == "iPad4,1" { return "iPad Air"}
    if platform == "iPad4,2" { return "iPad Air"}
    if platform == "iPad4,3" { return "iPad Air"}
    if platform == "iPad4,4" { return "iPad Mini 2"}
    if platform == "iPad4,5" { return "iPad Mini 2"}
    if platform == "iPad4,6" { return "iPad Mini 2"}
    if platform == "iPad4,7" { return "iPad Mini 3"}
    if platform == "iPad4,8" { return "iPad Mini 3"}
    if platform == "iPad4,9" { return "iPad Mini 3"}
    if platform == "iPad5,1" { return "iPad Mini 4"}
    if platform == "iPad5,2" { return "iPad Mini 4"}
    if platform == "iPad5,3" { return "iPad Air 2"}
    if platform == "iPad5,4" { return "iPad Air 2"}
    if platform == "iPad6,3" { return "iPad Pro 9.7"}
    if platform == "iPad6,4" { return "iPad Pro 9.7"}
    if platform == "iPad6,7" { return "iPad Pro 12.9"}
    if platform == "iPad6,8" { return "iPad Pro 12.9"}
    
    if platform == "i386"   { return "iPhone Simulator"}
    if platform == "x86_64" { return "iPhone Simulator"}
    
    return platform
}


func getMultipler()-> CGFloat{
     let type = iphoneType()
    if UIDevice.current.model == "iPad"{
        
        print(UIDevice.current.model)
        return 4/3
    }else if type == "iPhone X" {
        return 5/6
    }
    else {
        return 1
    }
}

//func getRandomNumber(range: ClosedRange<Int> = 1...6) -> Int {
//    let min = range.lowerBound
//    let max = range.upperBound
//    return Int(arc4random_uniform(UInt32(1 + max - min))) + min
//}

