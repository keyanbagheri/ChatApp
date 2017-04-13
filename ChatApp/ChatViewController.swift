//
//  ChatViewController.swift
//  ChatApp
//
//  Created by bitbender on 4/7/17.
//  Copyright © 2017 Key + Max. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class ChatViewController: UIViewController {
    @IBOutlet weak var chatTableView: UITableView!
    
    @IBOutlet weak var inputTextField: UITextView!
    
    var currentUser : FIRUser? = FIRAuth.auth()?.currentUser
    var recipientUser : User?
    var currentChat : Chat = Chat()
    var lastId : Int = 0
    
    var ref: FIRDatabaseReference!
    var messages : [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
        ref = FIRDatabase.database().reference()
        
        if let email = currentUser?.email {
            self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Helvetica-Bold", size: 18)!]
            if email == currentChat.userEmails[0] {
                self.navigationItem.title = "\(currentChat.userScreenNames[1])"
            } else {
                self.navigationItem.title = "\(currentChat.userScreenNames[0])"
            }
        }
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
        
        listenToFirebase()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func listenToFirebase() {
        ref.child("chat").child(currentChat.id).child("messages").observe(.value, with: { (snapshot) in
            print("Value : " , snapshot)
        })
        
        // 2. get the snapshot
        ref.child("chat").child(currentChat.id).child("messages").observe(.childAdded, with: { (snapshot) in
            print("Value : " , snapshot)
            
            // 3. convert snapshot to dictionary
            guard let info = snapshot.value as? NSDictionary else {return}
            // 4. add student to array of messages
            self.addToChat(id: snapshot.key, messageInfo: info)
            
            // sort
            self.messages.sort(by: { (message1, message2) -> Bool in
                return message1.id < message2.id
            })
            
            // set last message id to last id
            if let lastMessage = self.messages.last {
                self.lastId = lastMessage.id
            }
            
            // 5. update table view
            self.chatTableView.reloadData()
            self.tableViewScrollToBottom()
            
        })
        
        ref.child("chat").child(currentChat.id).child("messages").observe(.childRemoved, with: { (snapshot) in
            print("Value : " , snapshot)
            
            guard let deletedId = Int(snapshot.key)
                else {return}
            
            if let deletedIndex = self.messages.index(where: { (msg) -> Bool in
                return msg.id == deletedId
            }) {
                self.messages.remove(at: deletedIndex)
                let indexPath = IndexPath(row: deletedIndex, section: 0)
                self.chatTableView.deleteRows(at: [indexPath], with: .right)
            }
            
            // to delete :
            //            self.ref.child("path").removeValue()
            //            self.ref.child("student").child("targetId").removeValue()
        })
        
        
    }
    
    @IBAction func sendButtonClicked(_ sender: Any) {
        
        let currentDate = NSDate()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd HH:mm"
        let timeCreated = dateFormatter.string(from: currentDate as Date)
        
        
        if let userName = currentUser?.email,
            let body = inputTextField.text {
            // write to firebase
            lastId = lastId + 1
            let post : [String : Any] = ["userID": currentUser!.uid, "userEmail": currentUser!.email, "body": body, "image" : "nil", "timestamp": timeCreated]
            
            ref.child("chat").child(currentChat.id).child("messages").child("\(lastId)").updateChildValues(post)
            
            
            inputTextField.text = ""
        }
    }
    
    
    func addToChat(id : Any, messageInfo : NSDictionary) {
        
        if let userID = messageInfo["userID"] as? String,
            let userEmail = messageInfo["userEmail"] as? String,
            let body = messageInfo["body"] as? String,
            let imageURL = messageInfo["image"] as? String,
            let messageId = id as? String,
            let timeCreated = messageInfo["timestamp"] as? String,
            let currentMessageId = Int(messageId) {
            let newMessage = Message(anId : currentMessageId, aUserID : userID, aUserEmail : userEmail, aBody : body, anImageURL: imageURL, aDate : timeCreated)
            self.messages.append(newMessage)
            
        }
        
        
    }
    
    @IBAction func uploadImageButton(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func dismissImagePicker() {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(_ image: UIImage) {
        
        let ref = FIRStorage.storage().reference()
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {return}
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpeg"
        ref.child("\(currentUser?.email)-\(createTimeStamp()).jpeg").put(imageData, metadata: metaData) { (meta, error) in
            
            if let downloadPath = meta?.downloadURL()?.absoluteString {
                //save to firebase database
                self.saveImagePath(downloadPath)
            }
            
        }
        
        
    }
    
    func createTimeStamp() -> String {
        
        let currentDate = NSDate()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd HH:mm"
        let timeCreated = dateFormatter.string(from: currentDate as Date)
        
        return timeCreated
        
    }
    
    func saveImagePath(_ path: String) {
        lastId = lastId + 1
        
        let chatValue : [String: Any] = ["userID": currentUser!.uid, "userEmail": currentUser!.email, "body":"\(currentUser!.uid)-\(createTimeStamp())", "timestamp": createTimeStamp(), "image": path]
        
        ref.child("chat").child(currentChat.id).child("messages").child("\(lastId)").updateChildValues(chatValue)
    }
}


extension ChatViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        defer {
            dismissImagePicker()
        }
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        //display / store
        uploadImage(image)
        
    }
    
    func uniqueFileForUser(_ name: String) -> String {
        let currentDate = Date()
        return "\(name)_\(currentDate.timeIntervalSince1970).jpeg"
    }
    
    
}


extension ChatViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentMessage = messages[indexPath.row]
        
        if currentMessage.imageURL != "nil" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell") as? ImageTableViewCell else {return UITableViewCell()}
            
            if currentMessage.userEmail == currentChat.userEmails[0] {
                cell.nameLabel.text = currentChat.userScreenNames[0]
            } else {
                cell.nameLabel.text = currentChat.userScreenNames[1]
            }
            
            
            let messageURL = currentMessage.imageURL
            cell.chatImageView.loadImageUsingCacheWithUrlString(urlString: messageURL)

            cell.timeSentLabel.text = currentMessage.timestamp
            
            
            
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell") as? ChatTableViewCell else {return UITableViewCell()}
            
            
            if currentMessage.userEmail == currentChat.userEmails[0] {
                cell.userNameLabel.text = currentChat.userScreenNames[0]
            } else {
                cell.userNameLabel.text = currentChat.userScreenNames[1]
            }
            
            cell.timeCreatedLabel.text = currentMessage.timestamp
            cell.bodyTextView.text = currentMessage.body
            
            return cell
            
        }
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let controller = storyboard .instantiateViewController(withIdentifier: "ImageViewController") as?
            ImageViewController else { return }
        
        controller.currentMessage = messages[indexPath.row]
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    
    func tableViewScrollToBottom() {
        let numberOfRows = self.chatTableView.numberOfRows(inSection: 0)
        
        if numberOfRows > 0 {
            let indexPath = IndexPath(row: numberOfRows - 1, section: 0)
            self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            
            
            let targetID = self.messages[indexPath.row].id
            
            //remove from database (modified)
            self.ref.child("path").removeValue()
            self.ref.child("chat").child(currentChat.id).child("messages").child("\(targetID)").removeValue()
            
            messages.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            
        }
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        if let mainNavi = storyboard?.instantiateViewController(withIdentifier: "TabBarController") {
            present(mainNavi, animated: true, completion: nil)
        }
    }
    
    
}



