//
//  SignUpViewController.swift
//
//
//  Created by bitbender on 4/10/17.
//
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    var ref: FIRDatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
        ref = FIRDatabase.database().reference()
        

    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        if let logInVC = storyboard?.instantiateViewController(withIdentifier: "AuthNavigationController") {
            present(logInVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text else {return}
        
        if email == "" || password == "" || confirmPassword == "" {
            print("Email / password cannot be empty")
        }
        
        if password != confirmPassword {
            print("Passwords do not match");
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            
            let defaultImageURL = "https://firebasestorage.googleapis.com/v0/b/chatapp2-8fc6d.appspot.com/o/icon1.png?alt=media&token=a0c137ff-3053-442b-a6fb-3ef06f818d6a"
            
            if error != nil {
                return
            }
            
            guard let user = user
                else {
                    print ("User not created error")
                    return
            }
            
            print("User ID \(user.uid) with email: \(String(describing: user.email)) created")
            
            let post : [String : String] = ["email": user.email!, "screenName": "ANONYMOUS", "desc": "Add a Description", "imageURL" : defaultImageURL]
            self.ref.child("users").child("\(user.uid)").updateChildValues(post)
            
            self.directToMainNaviController()
        }
    }
    func directToMainNaviController() {
        if let mainNavi = storyboard?.instantiateViewController(withIdentifier: "TabBarController") {
            present(mainNavi, animated: true, completion: nil)
        }
    }
}
