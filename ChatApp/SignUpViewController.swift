//
//  SignUpViewController.swift
//
//
//  Created by bitbender on 4/10/17.
//
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
        // ...
        //        }
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
            
            if error != nil {
                return
            }
            
            guard let user = user
                else {
                    print ("User not created error")
                    return
            }
            
            print("User ID \(user.uid) with email: \(String(describing: user.email)) created")
        }
    }
}
