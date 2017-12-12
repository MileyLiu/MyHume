//
//  UserInfo.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 12/12/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import Foundation
/*
 用户信息类
 */
class UserInfo:NSObject
{
    var username:String = ""
    var avatar:String = ""
    
    init(name:String, logo:String)
    {
        self.username = name
        self.avatar = logo
    }
}
