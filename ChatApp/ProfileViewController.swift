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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()

        // Do any additional setup after loading the view.
    }

//    func listenToFirebase() {
//
//        
//        ref.child("user").observe(.childChanged, with: {(snapshot) in
//            print("Changed :", snapshot)
//            
//            //infor -> snapshot.value, studentID -> snapshot.key
//            guard let info = snapshot.value as? NSDictionary,
//                let studentID = String(snapshot.key)
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
//            if let matchedIndex = self..index(where: { (student) -> Bool in
//                return student.id == studentID
//            }) {
//                
//                let changedStudent = self.students[matchedIndex]
//                changedStudent.name = name
//                changedStudent.age = age
//                let indexPath = IndexPath(row: matchedIndex, section: 0)
//                self.tableView.reloadRows(at: [indexPath], with: .fade)
//            }
//            
//            
//        })

}
