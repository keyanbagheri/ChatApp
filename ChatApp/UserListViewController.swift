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
    
    var usersList : [String] = []
    
    
    
    
    
    

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logoutButton(_ sender: Any) {
        
        
        
    }

}

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





