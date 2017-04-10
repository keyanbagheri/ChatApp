//
//  SignInViewController.swift
//
//
//  Created by bitbender on 4/10/17.
//
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if (FIRAuth.auth()?.currentUser) != nil {
            print("Some user already logged in")
            // go to main page
        }
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
    @IBAction func logInButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {return}
        
        if email == "" || password == "" {
            // show error
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            // ...
            
            if let err = error {
                print("Sign In ERror : \(err.localizedDescription)")
                return
            }
            
            guard let user = user else {
                print("User error")
                return
            }
            
            print("\(String(describing: user.email)) logged in successfully. UID: \(user.uid)")
            self.directToMainNaviController()
        }
    }
    
    func directToMainNaviController() {
        if let mainNavi = storyboard?.instantiateViewController(withIdentifier: "MainNavigationController") {
            present(mainNavi, animated: true, completion: nil)
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        if let signUpVC = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") {
            navigationController?.pushViewController(signUpVC, animated: true)
        }
    }
}
