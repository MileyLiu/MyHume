//
//  MessageItem.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 8/12/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import Foundation

import UIKit

//消息类型，我的还是别人的
enum ChatType {
    case Mine
    case Someone
}

class MessageItem {
    
    var image:String
    // var name:String
    //var id: String
    //var content:String
    var date:Date
    
    // var comment:ALComplain.Comment
    
    //消息类型
    var mtype:ChatType
    //内容视图，标签或者图片
    var view:UIView
    //边距
    var insets:UIEdgeInsets
    
    //设置我的文本消息边距
    class func getTextInsetsMine() -> UIEdgeInsets {
        return UIEdgeInsets(top:15, left:10, bottom:11, right:17)
    }
    
    //设置他人的文本消息边距
    class func getTextInsetsSomeone() -> UIEdgeInsets {
        return UIEdgeInsets(top:15, left:15, bottom:20, right:10)
    }
    
    //设置我的图片消息边距
    class func getImageInsetsMine() -> UIEdgeInsets {
        return UIEdgeInsets(top:11, left:13, bottom:16, right:22)
    }
    
    //设置他人的图片消息边距
    class func getImageInsetsSomeone() -> UIEdgeInsets {
        return UIEdgeInsets(top:11, left:13, bottom:16, right:22)
    }
    
    //构造文本消息体
    convenience init(body:NSString, image:String, date:Date, mtype:ChatType) {
        let font =  UIFont.boldSystemFont(ofSize: 12)
        
        let width =  225, height = 10000.0
        
        let atts =  [NSAttributedStringKey.font: font]
        
        let size =  body.boundingRect(with: CGSize(width:CGFloat(width),height: CGFloat(height)),
                                      options: .usesLineFragmentOrigin, attributes:atts, context:nil)
        
        //   let datelabel=UILabel(frame:CGRect(x:0, y:0, width:size.size.width,height: size.size.height*0.3))
        
        let label =  UILabel(frame:CGRect(x:0, y:size.size.height*0.3, width:size.size.width,height: size.size.height))
        
        
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.text = (body.length != 0 ? body as String : "")
        label.font = font
        label.backgroundColor = UIColor.clear
        
        let insets:UIEdgeInsets =  (mtype == ChatType.Mine ?
            MessageItem.getTextInsetsMine() : MessageItem.getTextInsetsSomeone())
        
        self.init(image:image, date:date, mtype:mtype, view:label, insets:insets)
        
        
    }
    
    //可以传入更多的自定义视图
    init(image:String, date:Date, mtype:ChatType, view:UIView, insets:UIEdgeInsets) {
        self.view = view
        self.image = image
        self.date = date
        self.mtype = mtype
        self.insets = insets
    }
}
