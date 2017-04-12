//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by bitbender on 4/12/17.
//  Copyright © 2017 Key + Max. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController {
    
    var currentUser : FIRUser? = FIRAuth.auth()?.currentUser
    var ref: FIRDatabaseReference!
    var currentUserID : String = ""
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var editProfileButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()

        if let id = currentUser?.uid {
            print(id)
            currentUserID = id
        }
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            
            //logged out
            //go to sign in page
            if let signInVC = storyboard?.instantiateViewController(withIdentifier: "AuthNavigationController") {
                present(signInVC, animated: true, completion: nil)
            }
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    

//    func listenToFirebase() {
//
//        
//        ref.child("user").observe(.childChanged, with: {(snapshot) in
//            print("Changed :", snapshot)
//            
//            //infor -> snapshot.value, studentID -> snapshot.key
//            guard let info = snapshot.value as? NSDictionary,
//                let userID = String(snapshot.key)
//                else {return}
//            
//            
//            //get age and name from the "info/snapshot value"
//            guard let screenName = info["screenName"] as? String,
//                let description = info["dsc"] as? String,
//                let imageURL = info["imageURL"] as? String
//                else {return}
//            
//            //get first index where studentID is matched
//            if let matchedID = currentUser?.uid {
//                
//                let changedUser =
//                changedStudent.name = name
//                changedStudent.age = age
//                let indexPath = IndexPath(row: matchedIndex, section: 0)
//                self.tableView.reloadRows(at: [indexPath], with: .fade)
//            }
//            
//            
//        })
//
//}
    
    func changeProfile() {
        let screenName = nameTextField.text
        
        let post : [String : Any] = ["screenName": screenName,
                                     "desc" : "",
                                     "imageURL": ""]
        
        //                    //method 1
        //                    let childUpdates = ["/student/\(key)": post]
        //                    ref.updateChildValues(childUpdates)
        
        ref.child("user").child("\(currentUserID)").updateChildValues(post)
        
        
    }
    
}
