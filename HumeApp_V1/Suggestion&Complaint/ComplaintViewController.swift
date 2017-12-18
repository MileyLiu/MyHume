//
//  ComplaintViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 10/11/17.
//  Copyright © 2017 MileyLiu. All rights reserved.

//reference：http://m.hangge.com/news/cache/detail_559.html
//

import UIKit

class ComplaintViewController: UIViewController,ChatDataSource,UITextFieldDelegate,UITextViewDelegate{
    
    var titleString: String?
//    var keyBoardHeight: Double?
    
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
    var txtMsgTextView: UITextView!
    
    var viewWidth : CGFloat!
    var viewHight : CGFloat!

    
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
        //KEYBORAD
       
        
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
        txtMsg.font=UIFont.boldSystemFont(ofSize: messageFontSize)
        txtMsg.layer.cornerRadius = 10.0
        txtMsg.returnKeyType = UIReturnKeyType.send
      
        txtMsg.leftView = UIView.init(frame: CGRect(x:0,y:0,width:10,height:0))
        txtMsg.leftViewMode = .always
        txtMsg.tintColor = mainColor

        txtMsg.configKeyboard()
        //Set the delegate so you can respond to user input
       
        sendView.addSubview(txtMsg)
        self.view.addSubview(sendView)
        
        let sendButton = UIButton(frame:CGRect(x: screenWidth - 80,y: 10,width: 72,height: 36))
        sendButton.backgroundColor = mainColor
        sendButton.addTarget(self, action:#selector(ComplaintViewController.sendMessage) ,
                             for:UIControlEvents.touchUpInside)
        sendButton.layer.cornerRadius=6.0
        sendButton.setTitle("Send", for:UIControlState())
        sendView.addSubview(sendButton)
        
        
        
        txtMsg.delegate=self
        
        
        //点击其他部分收起键盘
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)

    }
    
    func configKeyboardAction(KbHeight:Double){
//         txtMsg.configKeyboard()
        
        
//        let frame = textField.frame
        let height = self.view.frame.size.height
        let width = self.view.frame.size.width
        
        print("kbHeight:\(KbHeight)")
        let offset = KbHeight
        print("offset:\(offset)")
        let animationDuration = TimeInterval(0.30)
        
        UIView.beginAnimations("ResizeForKeyBoard", context: nil)
        UIView.setAnimationDuration(animationDuration)
        let rect = CGRect.init(x: 0, y: CGFloat(-offset), width: width, height: height)
        self.view.frame = rect
      
        UIView.commitAnimations()
     
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
        
        
        
    }
    
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        

        NotificationCenter.default.addObserver(
            self,

            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        
        print("textFieldDidBeginEditing")

        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        
        let height = self.view.frame.size.height
        let width = self.view.frame.size.width
         let animationDuration = TimeInterval(0.30)
        UIView.beginAnimations("ResizeForKeyBoard", context: nil)
        UIView.setAnimationDuration(animationDuration)
    
        let rect = CGRect.init(x: 0, y: 0, width: width, height: height)
        self.view.frame = rect
        
         UIView.commitAnimations()
        
    }
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
        
        
        let aboCurrentTime = "\(Int(currentDateTime.timeIntervalSince1970))"
        
        
        let replayDateTime = Date().addingTimeInterval(1.0)
        
        // initialize the date formatter and set the style
       
        
        // get the date time String from the date object
        let replayTime = formatter.string(from: replayDateTime)
         print("replayTime:\(replayTime)")
        
        let aboReplyDateTime = "\(Int(replayDateTime.timeIntervalSince1970))"
        
        
        
        
        let myMsg = MessageModel.init(content: textingContent, type: ChatType.mine, category: titleString!, time: aboCurrentTime)
        let replyMsg = MessageModel.init(content: "We have received your message, will check soon", type: ChatType.someone, category: titleString!, time: aboReplyDateTime)
        
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
        
        
        let zero =  MessageItem(body:"Please talk with us", user:you,  date:Date(timeIntervalSinceNow:-900964), mtype:.someone)
        
        for  i in 0..<dataSource.count{
            
            //Todo  transfer date
            let messageModel = self.dataSource[i] as! MessageModel
            
            if messageModel.type == .mine {
                
                let timeStamp = (messageModel.time as NSString).intValue
                
                print("timestep1:\(timeStamp)")
                let timeInterval:TimeInterval = TimeInterval(timeStamp)
                let msgDate1 = Date(timeIntervalSince1970: timeInterval)

                let messageItem_me = MessageItem.init(body: messageModel.content as NSString, user: me, date: msgDate1, mtype: .mine)
                
              messageItems.add(messageItem_me)
            }
            else if messageModel.type == .someone{
                 let timeStamp = (messageModel.time as NSString).intValue
                
                 let timeInterval:TimeInterval = TimeInterval(timeStamp)
                
                let msgDate2 = Date(timeIntervalSince1970: timeInterval)
                
                
                let messageItem_you = MessageItem.init(body: messageModel.content as NSString, user: you, date: msgDate2 , mtype: .someone)
                messageItems.add(messageItem_you)

            }


        }
        
      
        
        Chats = NSMutableArray()
        
        Chats.addObjects(from: [zero])
        Chats.addObjects(from: messageItems as! [Any])
     
        
        //set the chatDataSource
        self.tableView.chatDataSource = self
        
        
        //call the reloadData, this is a    ctually calling your override method
        self.tableView.reloadData()
        
         self.view.addSubview(self.tableView)
        
        self.scrollToBottom()
//
//        self.view.addSubview(self.tableView)
        
        //跳到table底部
        
//
//        let sections =  self.tableView.bubbleSection.count - 1
//
//       let indexPath =  IndexPath(row:(self.tableView.bubbleSection[sections] as AnyObject).count,section:sections)
//
////        self.tableView.scrollToRow(at: indexPath,                at:UITableViewScrollPosition.bottom,animated:true)
////
//
//        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//
//

        
//        self.tableView.reloadData()
        
   
        
        
        
        //        let indexPath = IndexPath(row: Chats.count-1, section: 0)
        //        if(Chats.count-1>0){
        //            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        //
        //        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(false)
        self.tableView.setContentOffset(CGPoint(x:0,y:CGFloat.greatestFiniteMagnitude), animated: false)
    }


    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(false)
        if self.tableView.contentSize.height > self.tableView.frame.size.height
        {

            let offset = CGPoint(x:0, y: self.tableView.contentSize.height - self.tableView.frame.size.height)

            self.tableView.setContentOffset(offset, animated: false)
        }
    }
    
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyBoardHeight = Double(keyboardRectangle.height)
            print("keyboardHeight:\(keyBoardHeight)")
            
            configKeyboardAction(KbHeight: keyBoardHeight)
            
            
        }
    }
    
    
    func scrollToBottom() {
        
        
        var yOffset = CGFloat(0)
        let distance = self.tableView.contentSize.height-self.tableView.bounds.size.height
        
    
        
       //设置要滚动的位置 0最顶部 CGFLOAT_MAX最底部
        if (distance>0) {
            yOffset = distance
        }
        
        
        print("yOffest:\(yOffset)")
        self.tableView.setContentOffset(CGPoint(x:0,y:yOffset), animated: false)
       
        
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
