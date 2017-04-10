//
//  UserListViewController.swift
//  ChatApp
//
//  Created by Max Jala on 10/04/2017.
//  Copyright © 2017 Key + Max. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UserListViewController: UIViewController {
    
    
    
    @IBOutlet weak var usersTableView: UITableView!
    
    var ref: FIRDatabaseReference!
    
    var currentUser : FIRUser? = FIRAuth.auth()?.currentUser
    
    var usersList : [User] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()

        if let email = currentUser?.email {
            self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Helvetica", size: 12)!]
            self.navigationItem.title = "Logged in as: \(email)"
        }
        
        usersTableView.delegate = self
        usersTableView.dataSource = self
        
        listenToFirebase()
        
        print("UID -> \(FIRAuth.auth()?.currentUser?.uid)")
        
    }

    
    
    func listenToFirebase() {
        ref.child("users").observe(.value, with: { (snapshot) in
            print("Value : " , snapshot)
        })
        
        // 2. get the snapshot
        ref.child("users").observe(.childAdded, with: { (snapshot) in
            print("Value : " , snapshot)
            
            // 3. convert snapshot to dictionary
            guard let info = snapshot.value as? NSDictionary else {return}
            // 4. add student to array of messages
            self.addToList(id: snapshot.key, userInfo: info)
            
            // sort
            self.usersList.sort(by: { (user1, user2) -> Bool in
                return user1.email < user2.email
            })
            
            
            // 5. update table view
            self.usersTableView.reloadData()
            self.tableViewScrollToBottom()
            
        })
        
        ref.child("users").observe(.childRemoved, with: { (snapshot) in
            print("Value : " , snapshot)
            
            guard let deletedId = snapshot.key as? String
                else {return}
            
            if let deletedIndex = self.usersList.index(where: { (user) -> Bool in
                return user.id == deletedId
            }) {
                self.usersList.remove(at: deletedIndex)
                let indexPath = IndexPath(row: deletedIndex, section: 0)
                self.usersTableView.deleteRows(at: [indexPath], with: .right)
            }
            
            // to delete :
            //            self.ref.child("path").removeValue()
            //            self.ref.child("student").child("targetId").removeValue()
        })
        
        
    }
    
    func addToList(id : Any, userInfo : NSDictionary) {
        
        if let email = userInfo["email"] as? String,
            let userID = id as? String {
            let newUser = User(anId : userID, anEmail : email)
            self.usersList.append(newUser)
            
        }
        
        
    }
    
//    func addToChat(id : Any, messageInfo : NSDictionary) {
//        
//        if let userName = messageInfo["userName"] as? String,
//            let body = messageInfo["body"] as? String,
//            let messageId = id as? String,
//            let timeCreated = messageInfo["timeCreated"] as? String,
//            let currentMessageId = Int(messageId) {
//            let newMessage = Message(anId : currentMessageId, aName : userName, aBody : body, aDate : timeCreated)
//            self.messages.append(newMessage)
//            
//        }
//        
//        
//    }
    
//    func addToList(userInfo : NSDictionary) {
//        
//        if let email = userInfo["email"] as? String {
//            let newUser = User(anEmail : email)
//            self.usersList.append(newUser)
//            
//        }
//        
//        
//    }
    
    

    @IBAction func logoutButtonTapped(_ sender: Any) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            
            if let logInVC = storyboard?.instantiateViewController(withIdentifier: "AuthNavigationController") {
                present(logInVC, animated: true, completion: nil)
            }
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }

}

//TABLEVIEW DELEGATE AND DATASOURCE

extension UserListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userTableViewCell") as? UserTableViewCell
            else {return UITableViewCell()}
        let specificUser = usersList[indexPath.row]
        cell.userEmailLabel.text = specificUser.email
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let controller = storyboard .instantiateViewController(withIdentifier: "ChatViewController") as?
            ChatViewController else { return }
        
        let selectedPerson = usersList[indexPath.row]
        
        let newChat = Chat(anId: <#T##Int#>, userOne: <#T##User#>, userTwo: <#T##User#>)
        
        
        controller.recipientUser = selectedPerson
        //controller.currentChat?.users = [currentUser, selectedPerson]
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    
    func tableViewScrollToBottom() {
        let numberOfRows = self.usersTableView.numberOfRows(inSection: 0)
        
        if numberOfRows > 0 {
            let indexPath = IndexPath(row: numberOfRows - 1, section: 0)
            self.usersTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            
            
            let targetID = self.usersList[indexPath.row]// .id
            
            //remove from database (modified)
            self.ref.child("path").removeValue()
            self.ref.child("users").child("\(targetID)").removeValue()
            
            usersList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            
        }
    }
    
    
    
    
}





