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
    }

    
    /*
    func listenToFirebase() {
        ref.child("message").observe(.value, with: { (snapshot) in
            print("Value : " , snapshot)
        })
        
        // 2. get the snapshot
        ref.child("message").observe(.childAdded, with: { (snapshot) in
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
        
        ref.child("message").observe(.childRemoved, with: { (snapshot) in
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
*/
    

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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "usersTableViewCell") as? ChatTableViewCell else {return UITableViewCell()}
        //let specificUser = usersList[indexPath.row]
        cell.userNameLabel.text = ""
        
        return cell
        
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





