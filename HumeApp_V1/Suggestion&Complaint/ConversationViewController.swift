//
//  ConversationViewController.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 8/12/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ConversationViewController: JSQMessagesViewController {
    
    var messages = [JSQMessage]()
    let defaults = UserDefaults.standard
    var conversation: Conversation?
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    fileprivate var displayName: String!
    var titleString: String?


    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: UIBarButtonItemStyle.plain,
            target: nil,
            action: nil)
        
         self.title = titleString
       
//        if defaults.bool(forKey: removeBubbleTails.rawValue) {
            // Make taillessBubbles
//            incomingBubble = JSQMessagesBubbleImageFactory(bubble: UIImage.jsq_bubbleCompactTailless(), capInsets: UIEdgeInsets.zero, layoutDirection: UIApplication.shared.userInterfaceLayoutDirection).incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
//            outgoingBubble = JSQMessagesBubbleImageFactory(bubble: UIImage.jsq_bubbleCompactTailless(), capInsets: UIEdgeInsets.zero, layoutDirection: UIApplication.shared.userInterfaceLayoutDirection).outgoingMessagesBubbleImage(with: UIColor.lightGray)
//        }
//        else {
            // Bubbles with tails
            incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
            outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.lightGray)
////        }
        
        /**
         *  Example on showing or removing Avatars based on user settings.
         */
        
//        if defaults.bool(forKey: Setting.removeAvatar.rawValue) {
//            collectionView?.collectionViewLayout.incomingAvatarViewSize = .zero
//            collectionView?.collectionViewLayout.outgoingAvatarViewSize = .zero
//        } else {
//            collectionView?.collectionViewLayout.incomingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height:kJSQMessagesCollectionViewAvatarSizeDefault )
//            collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height:kJSQMessagesCollectionViewAvatarSizeDefault )
////        }
        
        // Show Button to simulate incoming messages
        
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.jsq_defaultTypingIndicator(), style: .plain, target: self, action: #selector(receiveMessagePressed))
//
//        // This is a beta feature that mostly works but to make things more stable it is diabled.
//        collectionView?.collectionViewLayout.springinessEnabled = false
//
//        automaticallyScrollsToMostRecentMessage = true
//
//        self.collectionView?.reloadData()
//        self.collectionView?.layoutIfNeeded()

        // Do any additional setup after loading the view.
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
