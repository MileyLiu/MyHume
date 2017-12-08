//
//  ComplaintViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 10/11/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit

class ComplaintViewController: UIViewController,ChatDataSource,UITextFieldDelegate{
    var viewWidth:CGFloat!
    var viewHight:CGFloat!
     var Chats = [MessageItem]()
//    let selfurl:String="http://mtx.baibaidu.com/upload/10/13/10/15/xs3paor3eyl.jpg"
    let selfurl:String = "http://tc.sinaimg.cn/maxwidth.800/tc.service.weibo.com/static_jinrongbaguanv_com/5886a925e3bd5fc2a3adf8f9a36324c8.png"
    let otherUrl: String = "http://p3.wmpic.me/article/2015/03/16/1426483394_eJakzHWr.jpeg"
    var tableView:MessageTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewWidth=view.frame.width
        viewHight=view.frame.height
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: UIBarButtonItemStyle.plain,
            target: nil,
            action: nil)
        
        setupChatTable()
        
    }
    
    /*创建表格及数据*/
    func setupChatTable() {
        
        
        self.tableView = MessageTableView(frame:CGRect(x:0,y:64,width:viewWidth,height:viewHight-105), style: .plain)
        
        //创建一个重用的单元格
        self.tableView!.register(MessageTableViewCell.self, forCellReuseIdentifier: "MsgCell")
        
        
        let myMsg1 = MessageItem(body: "first message", image: selfurl, date: Date(timeIntervalSinceNow:-600), mtype: ChatType.Mine)
        
        let myMsg2 = MessageItem(body: "second message", image: selfurl, date: Date(timeIntervalSinceNow:-500), mtype: ChatType.Mine)
        
        let otherMsg1 =  MessageItem(body:"first reply Meaggg",image:otherUrl,date: Date(timeIntervalSinceNow:-400), mtype:ChatType.Someone)
        
        let otherMsg2 =  MessageItem(body:"second reply Meaggg",image:otherUrl,date: Date(timeIntervalSinceNow:-300), mtype:ChatType.Someone)
        
        var array : [MessageItem] = [myMsg1,otherMsg1,myMsg2,otherMsg2]
        
        
        Chats.append(contentsOf: array)
        
        
        
        
        
        
       
//        for comment in commentsArray{
//
//            if(comment.id==selfId){
//                let myMsg =  MessageItem(body:comment.content as NSString, image:comment.image,
//                                         date:Date(timeIntervalSinceNow:-600), mtype:ChatType.Mine)
//                print("myheadphoto:\(comment.image)")
//                Chats.append(myMsg)
//            }
//            else{
//
//                print("othersid:\(comment.id)")
//                let otherMsg =  MessageItem(body:comment.content as NSString, image:comment.image,
//                                            date:Date(timeIntervalSinceNow:-600), mtype:ChatType.Someone)
//                print("otherheadphoto:\(comment.image)")
//
//                Chats.append(otherMsg)
//            }
//
//        }
        
        self.tableView.chatDataSource = self
        self.tableView.reloadData()
        self.view.addSubview(self.tableView)
        
        //跳到table底部
        let indexPath = IndexPath(row: Chats.count-1, section: 0)
        if(Chats.count-1>0){
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        print("nannycomplainid222222:\(sentComplain?.id)")
        //  for commitDic in (complainToExpand?.comments)!{
        
        
        //      print("nannycomplaindetai22222:\(commitDic.id)")
        //      commentsArray.append(commitDic)
        //   }
        //    commentsArray.remove(at: 0)
        
        if(Chats.count-1>0){
            let indexPath = IndexPath(row: Chats.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            
        }
    }
    func rowsForChatTable(tableView:MessageTableView) -> Int {
        print("countttttttttttttttttttttt:\(self.Chats.count)")
        return self.Chats.count
        
    }
    
    /*返回某一行的内容*/
    func chatTableView(tableView:MessageTableView, dataForRow row:Int) -> MessageItem {
        return Chats[row]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
