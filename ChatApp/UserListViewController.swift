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
    
    var currentUserID : String = ""
    var currentUserEmail: String = ""
    
    var usersList : [User] = []
    
    var personalisedUserList : [User] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()

        if let email = currentUser?.email {
            currentUserEmail = email
            self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Helvetica", size: 12)!]
            self.navigationItem.title = "Logged in as: \(email)"
        }
        
        if let id = currentUser?.uid {
            print(id)
            currentUserID = id
        }
        
        usersTableView.delegate = self
        usersTableView.dataSource = self
        
        listenToFirebase()
        //createPersonalisedUserList()
        filterForCurrentUserObject()
        
        
        
        
        
//        print("UID -> \(FIRAuth.auth()?.currentUser?.uid)")
        
    }
    
//    func createPersonalisedUserList() {
//        self.personalisedUserList = usersList.filter {
//            
//            return $0.email.range(of: "\(FIRAuth.auth()?.currentUser?.email)") == nil
//        }
//        usersTableView.reloadData()
//    }
    
    func createPersonalisedUserList() {
        if usersList.count > 0 {
            
        for user in usersList {
            if user.id != "\(FIRAuth.auth()?.currentUser?.uid)" {
                personalisedUserList.append(user)
            }
        }
            
        } else {
            return
        }
    }
    
    func filterForCurrentUserObject() {
        var filteredUserArray : [User] = []
        
        for user in usersList {
            if user.email == "\(FIRAuth.auth()?.currentUser?.uid)" {
                filteredUserArray.append(user)
            }
        }
//        self.currentUser = filteredUserArray
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //createPersonalisedUserList()
        
    }

    
    
    func listenToFirebase() {
        ref.child("users").observe(.value, with: { (snapshot) in
            print("Value : " , snapshot)
            
            //self.createPersonalisedUserList()
        })
        
        // 2. get the snapshot
        ref.child("users").observe(.childAdded, with: { (snapshot) in
            print("Value : " , snapshot)
            
            // 3. convert snapshot to dictionary
            guard let info = snapshot.value as? NSDictionary else {return}
            // 4. add student to array of messages
            self.addToUserList(id: snapshot.key, userInfo: info)
            
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
        
    
    //createPersonalisedUserList()
    
    }
    
    func addToUserList(id : Any, userInfo : NSDictionary) {
        
        if let email = userInfo["email"] as? String,
            let userID = id as? String {
            let newUser = User(anId : userID, anEmail : email)
            self.usersList.append(newUser)
            
        }
        
        
    }
    
    

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
        
        var userIDs = [currentUserID, selectedPerson.id]
        
        userIDs.sort(by: { (user1, user2) -> Bool in
            return user1 < user2
        })
        
        let chatID = "\(userIDs[0])-\(userIDs[1])"
        
        let newChat = Chat(anId: chatID, userOneId: currentUserID , userTwoId: selectedPerson.id)
        
        ref.child("chat").child(newChat.id).observe(.value, with: { (snapshot) in
            
            if !snapshot.hasChildren() {
                let currentDate = NSDate()
                let dateFormatter:DateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-dd HH:mm"
                let timeCreated = dateFormatter.string(from: currentDate as Date)
                
                let post : [String : Any] = ["messages": ["0": ["body": "This is the beginning of the chat between \(selectedPerson.email) and \(self.currentUserEmail)", "image" : "nil", "timestamp": timeCreated, "userID": self.currentUserID, "userEmail": self.currentUserEmail]], "users": [self.currentUserID: self.currentUserEmail, selectedPerson.id: selectedPerson.email]]
                self.ref.child("chat").child(newChat.id).updateChildValues(post)
            }
            //self.createPersonalisedUserList()
        })
        
        
        controller.recipientUser = selectedPerson
        controller.currentChat = newChat
        
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





