//
//  ChatViewController.swift
//  ChatApp
//
//  Created by bitbender on 4/7/17.
//  Copyright © 2017 Key + Max. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChatViewController: UIViewController {

    @IBOutlet weak var chatTableView: UITableView!
    
    @IBOutlet weak var inputTextField: UITextView!

    var currentUser : String? = "anonymous"
    var lastId : Int = 0
    
    var ref: FIRDatabaseReference!
    var messages : [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ref = FIRDatabase.database().reference()
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
        listenToFirebase()
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
    
    func listenToFirebase() {
        ref.child("message").observe(.value, with: { (snapshot) in
            print("Value : " , snapshot)
        })
        
        // 2. get the snapshot
        ref.child("message").observe(.childAdded, with: { (snapshot) in
            print("Value : " , snapshot)
            
            // 3. convert snapshot to dictionary
            guard let info = snapshot.value as? NSDictionary else {return}
            // 4. add student to array of students
            self.addToChat(id: snapshot.key, messageInfo: info)
            
            // sort
            self.messages.sort(by: { (message1, message2) -> Bool in
                return message1.id > message2.id
            })
            
            // set last student id to last id
            if let lastMessage = self.messages.first {
                self.lastId = lastMessage.id
            }
            
            // 5. update table view
            self.chatTableView.reloadData()
            
        })
        
//        ref.child("message").observe(.childRemoved, with: { (snapshot) in
//            print("Value : " , snapshot)
//            
//            guard let deletedId = Int(snapshot.key)
//                else {return}
//            
//            if let deletedIndex = self.messages.index(where: { (msg) -> Bool in
//                return msg.id == deletedId
//            }) {
//                self.messages.remove(at: deletedIndex)
//                let indexPath = IndexPath(row: deletedIndex, section: 0)
//                self.chatTableView.deleteRows(at: [indexPath], with: .right)
//            }
//            
//            // to delete :
//            //            self.ref.child("path").removeValue()
//            //            self.ref.child("student").child("targetId").removeValue()
//        })
    }
    
    @IBAction func sendButtonClicked(_ sender: Any) {
        
        var currentDate = NSDate()
        var dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd HH:mm"
        var timeCreated = dateFormatter.string(from: currentDate as Date)
        
        
        if let userName = currentUser,
            let body = inputTextField.text {
            // write to firebase
            lastId = lastId + 1
            
            let post : [String : Any] = ["userName": userName, "body": body, "timeCreated": timeCreated]
            
            ref.child("message").child("\(lastId)").updateChildValues(post)
        }
    }


    func addToChat(id : Any, messageInfo : NSDictionary) {
//        var currentTime = "Just Now"
        
        if let userName = messageInfo["userName"] as? String,
            let body = messageInfo["body"] as? String,
            let messageId = id as? String,
            let timeCreated = messageInfo["timeCreated"] as? String,
            let currentMessageId = Int(messageId) {
            let newMessage = Message(anId : currentMessageId, aName : userName, aBody : body, aDate : timeCreated)
            self.messages.append(newMessage)
        }
        
        
    }
    
}

extension ChatViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell") as? ChatTableViewCell else {return UITableViewCell()}
        let currentMessage = messages[indexPath.row]
        cell.userNameLabel.text = "\(currentMessage.userName)"
        cell.timeCreatedLabel.text = currentMessage.timeCreated
        cell.bodyTextView.text = currentMessage.body
        return cell
    }
}
