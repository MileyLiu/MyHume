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
        
        let zero1 =  MessageItem(body:"I want to buy an apple", user:me,  date:Date(timeIntervalSinceNow:-90086400), mtype:.mine)
        
        let first =  MessageItem(body:"I have bought an apple", user:me,  date:Date(timeIntervalSinceNow:-90000600), mtype:.mine)
        
        
//        for data in dataSource{
//
//            print("contents:\(data.content)")
//
//            let msg = MessageItem.init(body: data.content as NSString, user: me, date: Date(timeIntervalSinceNow:-90000600) , mtype: .mine)
//
//            messageItems.append(msg)
//
////            Chats.addObjects(msg)
//
////            Chats.add(msg)
//        }
        
        
//        messageItems: NSMutableArray = NSMutableArray()
        
        for  i in 0..<dataSource.count{
            
            
            let messageModel = self.dataSource[i] as! MessageModel
            
            let messageItem = MessageItem.init(body: messageModel.content as NSString, user: me, date: Date(timeIntervalSinceNow:TimeInterval(-90000600+i*100)) , mtype: .mine)
           
            print("data:\(messageModel.content)")
            
            messageItems.add(messageItem)
            
        }
        
        
        print("messageItems\(messageItems.count)")
        
        
        
//        let second =  MessageItem(image:UIImage(named:"RedApple.jpg")!,user:me, date:Date(timeIntervalSinceNow:-90000290), mtype:.mine)
        
        let third =  MessageItem(body:"Very good",user:you, date:Date(timeIntervalSinceNow:-90000060), mtype:.someone)
        
//        let fouth =  MessageItem(body:"嗯，下次我们一起去吧！",user:me, date:Date(timeIntervalSinceNow:-90000020), mtype:.mine)
//        
//        let fifth =  MessageItem(body:"三年了，我终究没能看到这个风景",user:you, date:Date(timeIntervalSinceNow:0), mtype:.someone)
        
        
        Chats = NSMutableArray()
      
        Chats.addObjects(from: [first, third, zero, zero1])
        Chats.addObjects(from: messageItems as! [Any])
        
        //set the chatDataSource
        self.tableView.chatDataSource = self
        
         
        
        //call the reloadData, this is a    ctually calling your override method
        self.tableView.reloadData()
        
        self.view.addSubview(self.tableView)
        
        
//        for data in dataSource{
//
//
//            let model = data as! MessageModel
//            let currentDateTime = Date()
//
//            let myMsg = MessageItem.init(body: model.content as NSString, image: selfurl, date: currentDateTime, mtype: ChatType.Mine)
//
//
//            Chats.add(myMsg)
//
//        }
        
        
    
        
//        self.tableView.chatDataSource = self
//        self.tableView.reloadData()
//        self.view.addSubview(self.tableView)
//
//        //跳到table底部
//        let indexPath = IndexPath(row: Chats.count-1, section: 0)
//        if(Chats.count-1>0){
//            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//
//        }
    }
    
    
   
    
//    override func viewWillAppear(_ animated: Bool) {
//        //        print("nannycomplainid222222:\(sentComplain?.id)")
//        //  for commitDic in (complainToExpand?.comments)!{
//
//
//        //      print("nannycomplaindetai22222:\(commitDic.id)")
//        //      commentsArray.append(commitDic)
//        //   }
//        //    commentsArray.remove(at: 0)
//
//        if(Chats.count-1>0){
//            let indexPath = IndexPath(row: Chats.count-1, section: 0)
//            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//
//        }
//    }
//    func rowsForChatTable(_ tableView:MessageTableView) -> Int {
//        print("countttttttttttttttttttttt:\(self.Chats.count)")
//        return self.Chats.count
//        
//    }
//    
//    /*返回某一行的内容*/
//    func chatTableView(_ tableView:MessageTableView, dataForRow row:Int) -> MessageItem {
//        return Chats[row] as! MessageItem
//    }
//    
    
    
    
    
    
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
