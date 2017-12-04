//
//  TableViewHelper.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 26/10/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//


import Foundation
import UIKit

class TableViewHelper {
    
    class func EmptyMessage(message:String, viewController:UITableView) {
        let messageLabel = UILabel(frame: CGRect(x:0,y:0,width:viewController.bounds.size.width, height:viewController.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        viewController.backgroundView = messageLabel;
        viewController.separatorStyle = .none;
    }
    class func EmptyMessage(message:String, viewController:UICollectionView) {
        let messageLabel = UILabel(frame: CGRect(x:0,y:0, width: viewController.bounds.width, height:viewController.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        viewController.backgroundView = messageLabel
       
    }
    
//    class func collectionEmptyMessage(message:String, cviewController:UICollectionView) {
//        let messageLabel = UILabel(frame: CGRect(x:0,y:0,width:cviewController.view.bounds.size.width, height:cviewController.view.bounds.size.height))
//        messageLabel.text = message
//        messageLabel.textColor = UIColor.black
//        messageLabel.numberOfLines = 0;
//        messageLabel.textAlignment = .center
//        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
//        messageLabel.sizeToFit()
//
//        viewController..backgroundView = messageLabel;
//        viewController.tableView.separatorStyle = .none;
//    }
}

