//
//  ChatViewController.swift
//  ChatApp
//
//  Created by bitbender on 4/7/17.
//  Copyright © 2017 Key + Max. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var chatTableView: UITableView!
    
    @IBOutlet weak var inputTextField: UITextView!
    
    @IBOutlet weak var sendButton: UIButton!
    
    var currentUser : String? = "anonymous"
    var lastId : Int? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        ref.child("message").observe(.childChanged, with: { (snapshot) in
            print("Value : " , snapshot)
            
            //info > snapshot.value, studentId > snapshot.key
            guard let info = snapshot.value as? NSDictionary,
                let studentId = Int(snapshot.key) else {return}
            
            
            //get the age and name from the info snapshot value
            guard let age = info["age"] as? Int,
                let name = info["name"] as? String else {return}
            
            //            self.students.index(where: { (student) ->Bool in
            //                return student.id == studentID
            //            })
            //
            // get the first index where studentID is matched
            if let matchedIndex = self.students.index(where: { (studentElement) -> Bool in
                return studentElement.id == studentId
            }) {
                let changedStudent = self.students[matchedIndex]
                changedStudent.name = name
                changedStudent.age = age
                
                let indexPath = IndexPath(row: matchedIndex, section: 0)
                self.studentTableView.reloadRows(at: [indexPath], with: .fade)
            }
            
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


}
