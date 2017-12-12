//
//  ChatDataSource.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 8/12/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import Foundation

protocol ChatDataSource
{
    /*返回对话记录中的全部行数*/
    func rowsForChatTable( _ tableView:TableView) -> Int
    /*返回某一行的内容*/
    func chatTableView( _ tableView:TableView, dataForRow:Int)-> MessageItem
}

