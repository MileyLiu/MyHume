//
//  ComplaintViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 10/11/17.
//  Copyright © 2017 MileyLiu. All rights reserved.

//reference：http://m.hangge.com/news/cache/detail_559.html
//

import UIKit

class ComplaintViewController: UIViewController,ChatDataSource,UITextFieldDelegate{
    
    var titleString: String?
    
    func rowsForChatTable(_ tableView: TableView) -> Int {
        return self.Chats.count
    }
    
    func chatTableView(_ tableView: TableView, dataForRow: Int) -> MessageItem {
        return Chats[dataForRow] as! MessageItem
    }
    
    
    
    var Chats:NSMutableArray!
    var dataSource:NSMutableArray = NSMutableArray()
    var messageItems: NSMutableArray = NSMutableArray()
    var tableView:TableView!
    var me:UserInfo!
    var you:UserInfo!
    var txtMsg:UITextField!
    
    var viewWidth : CGFloat!
    var viewHight : CGFloat!
    
    
    
    
    let selfurl:String = "http://tc.sinaimg.cn/maxwidth.800/tc.service.weibo.com/static_jinrongbaguanv_com/5886a925e3bd5fc2a3adf8f9a36324c8.png"
    let otherUrl: String = "http://p3.wmpic.me/article/2015/03/16/1426483394_eJakzHWr.jpeg"
    
    
    //    @IBOutlet weak var typeTextView: UITextView!
    
    //    var dataSource : NSMutableArray = NSMutableArray()
    
    //    var titleString: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleString
        
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: UIBarButtonItemStyle.plain,
            target: nil,
            action: nil)
        
        
        
        dataSource = MessageModel.MessageFromDB(category: titleString!)
        
        
        print("dataSource:\(dataSource.count)")
        //        dataSource = MessageModel.MessageFromDB(category: "Delivery")
        //        print("dataSource:\(dataSource.count)")
        
        setupChatTable()
        setupSendPanel()
        
    }
    
    func setupSendPanel()
    {
        let screenWidth = UIScreen.main.bounds.width
        let sendView = UIView(frame:CGRect(x: 0,y: self.view.frame.size.height - 56,width: screenWidth,height: 56))
        
        sendView.backgroundColor=UIColor.lightGray
        sendView.alpha=0.9
        
        txtMsg = UITextField(frame:CGRect(x: 7,y: 10,width: screenWidth - 95,height: 36))
        txtMsg.backgroundColor = UIColor.white
        txtMsg.textColor=UIColor.black
        txtMsg.font=UIFont.boldSystemFont(ofSize: 12)
        txtMsg.layer.cornerRadius = 10.0
        txtMsg.returnKeyType = UIReturnKeyType.send
        
        //Set the delegate so you can respond to user input
        txtMsg.delegate=self
        sendView.addSubview(txtMsg)
        self.view.addSubview(sendView)
        
        let sendButton = UIButton(frame:CGRect(x: screenWidth - 80,y: 10,width: 72,height: 36))
        sendButton.backgroundColor = mainColor
        sendButton.addTarget(self, action:#selector(ComplaintViewController.sendMessage) ,
                             for:UIControlEvents.touchUpInside)
        sendButton.layer.cornerRadius=6.0
        sendButton.setTitle("Send", for:UIControlState())
        sendView.addSubview(sendButton)
    }
    func textFieldShouldReturn(_ textField:UITextField) -> Bool
    {
        sendMessage()
        return true
    }
    @objc func sendMessage()
    {
       
        
        if txtMsg.text != nil{
            saveMessageIntoDB(textingContent:txtMsg.text!)
        }
        
        //composing=false
        let sender = txtMsg
        
        
        let thisChat =  MessageItem(body:sender!.text! as NSString, user:me, date:Date(), mtype:ChatType.mine)
        
        let thatChat =  MessageItem(body:"We have received your message, will check soon" as NSString, user:you, date:Date(), mtype:ChatType.someone)
        
        
        Chats.add(thisChat)
        Chats.add(thatChat)
        
        
        self.tableView.chatDataSource = self
        self.tableView.reloadData()
        
        //self.showTableView()
        sender?.resignFirstResponder()
        sender?.text = ""
        
        
//        print("texting:\(txtMsg.text)")
        
       
        
        
//        if !(txtMsg.text?.isEmpty)!{
//
//            saveMessageIntoDB(content: (txtMsg.text?)!)
//        }
//        else {
//
//            print("enter some thing")
//        }
//
//
        
        
    }
    
    func saveMessageIntoDB(textingContent:String){
        
        
        let currentDateTime = Date()
        
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        
        // get the date time String from the date object
        let currentTime = formatter.string(from: currentDateTime)
        print("currentTime:\(currentTime)")
        
        
        
        let replayDateTime = Date().addingTimeInterval(1.0)
        
        // initialize the date formatter and set the style
       
        
        // get the date time String from the date object
        let replayTime = formatter.string(from: replayDateTime)
         print("replayTime:\(replayTime)")
        
        
        let myMsg = MessageModel.init(content: textingContent, type: ChatType.mine, category: titleString!, time: currentTime)
        let replyMsg = MessageModel.init(content: "We have received your message, will check soon", type: ChatType.someone, category: titleString!, time: replayTime)
        
        if myMsg.insertIfToDB(){
            
            if replyMsg.insertIfToDB(){
                
                print("addmesgae to db")
                
                
                
                
                
            }
        }
        
        
        
        
        
    }
    
    
    /*创建表格及数据*/
    func setupChatTable() {
        
        
        self.tableView = TableView(frame:CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: self.view.frame.size.height - 76), style: .plain)
        
        
        //创建一个重用的单元格
        self.tableView!.register(TableViewCell.self, forCellReuseIdentifier: "ChatCell")
        //        self.tableView!.register(TableView.self, forCellReuseIdentifier: "ChatCell")
        
        me = UserInfo(name:"customer" ,logo:("myself.png"))
        you  = UserInfo(name:"customerService", logo:("hume.jpg"))
        
        
        let zero =  MessageItem(body:"Please talk with us", user:you,  date:Date(timeIntervalSinceNow:-90096400), mtype:.someone)
        
        for  i in 0..<dataSource.count{
            
            //Todo  transfer date
            let messageModel = self.dataSource[i] as! MessageModel
            
            print("dataSturcture\(i):,\(messageModel.type)")
            
            
            if messageModel.type == .mine {

                let messageItem_me = MessageItem.init(body: messageModel.content as NSString, user: me, date: Date(timeIntervalSinceNow:TimeInterval(-90000600+i*100)) , mtype: .mine)

              messageItems.add(messageItem_me)
            }
            else if messageModel.type == .someone{

                let messageItem_you = MessageItem.init(body: messageModel.content as NSString, user: you, date: Date(timeIntervalSinceNow:TimeInterval(-90000600+i*100)) , mtype: .someone)

                messageItems.add(messageItem_you)

            }

//            messageItems.add(messageItem_me,messageItem_you)
            
            
//            let mseeageItem =  MessageItem.init(body: messageModel.content as NSString, user: me, date: Date(timeIntervalSinceNow:TimeInterval(-90000600+i*100)) , mtype: messageModel.type)
//
//            messageItems.add(mseeageItem)

            
            print("messageItems1:\(messageItems.count)")
//
//            messageItems.add(messageItem_me)
            
        }
        
        print("messageItems2:\(messageItems.count)")
        
        Chats = NSMutableArray()
        
        Chats.addObjects(from: [zero])
        Chats.addObjects(from: messageItems as! [Any])
     
        
        //set the chatDataSource
        self.tableView.chatDataSource = self
        
        
        //call the reloadData, this is a    ctually calling your override method
        self.tableView.reloadData()
        
        self.view.addSubview(self.tableView)
        
        //跳到table底部
        //        let indexPath = IndexPath(row: Chats.count-1, section: 0)
        //        if(Chats.count-1>0){
        //            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        //
        //        }
    }
    
    
    
    
    
    //    @IBAction func sendMessage(_ sender: Any) {
    //
    //        let currentDateTime = Date()
    //
    //        // initialize the date formatter and set the style
    //        let formatter = DateFormatter()
    //        formatter.timeStyle = .medium
    //        formatter.dateStyle = .long
    //
    //        // get the date time String from the date object
    //        let currentTime = formatter.string(from: currentDateTime)
    //
    //
    //        let sender = self.typeTextView.text
    //
    //        let msgItem = MessageItem(body: self.typeTextView.text as NSString, image: selfurl, date: Date(timeIntervalSinceNow:-500), mtype: ChatType.mine)
    //
    //        Chats.add(msgItem)
    //        print("Chats\(Chats.count)")
    //
    //
    //
    //
    //
    ////        if self.typeTextView.text != nil{
    //        let messageModel = MessageModel.init(content: self.typeTextView.text, type: ChatType.mine, category: "Delivery", time: currentTime)
    ////
    ////            print("currentTime:\(currentTime)")
    //            if messageModel.insertIfToDB(){
    //                print("update")
    //
    //                addNewItem(messageModel:messageModel)
    //
    //        }
    //
    //    }
    //
    //    func addNewItem(messageModel:MessageModel){
    //
    //
    //
    //
    //
    //
    //
    //    }
    //
    //
    
    
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
