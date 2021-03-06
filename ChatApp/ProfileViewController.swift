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
import FirebaseStorage

class ProfileViewController: UIViewController {
    
    var currentUser : FIRUser? = FIRAuth.auth()?.currentUser
    var ref: FIRDatabaseReference!
    var currentUserID : String = ""
    var profileScreenName : String = ""
    var profileImageURL : String = ""
    var profileEmail : String = ""
    var profileDesc : String = ""
    
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet{
            profileImageView.layer.cornerRadius = profileImageView.frame.width/2
            profileImageView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        ref = FIRDatabase.database().reference()

        if let id = currentUser?.uid {
            print(id)
            currentUserID = id
        }
        
        listenToFirebase()
        
    }
    
    func setUpProfile() {
        nameTextField.text = profileScreenName
        descriptionTextView.text = profileDesc
        emailLabel.text = profileEmail
        
        let messageURL = profileImageURL
        profileImageView.loadImageUsingCacheWithUrlString(urlString: messageURL)
        
        
        print("")
    }
    
    func listenToFirebase() {
        ref.child("users").child(currentUserID).observe(.value, with: { (snapshot) in
            print("Value : " , snapshot)
        
            let dictionary = snapshot.value as? [String: String]
            
            self.profileScreenName = (dictionary?["screenName"])!
            self.profileImageURL = (dictionary?["imageURL"])!
            self.profileEmail = (dictionary?["email"])!
            self.profileDesc = (dictionary?["desc"])!

            
            print("")
            
            self.setUpProfile()
        })
        
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
    
    @IBAction func editProfileButton(_ sender: Any) {
        
        let screenName = nameTextField.text
        let description = descriptionTextView.text
        let imageURL = "default.png"
        
        let post : [String : Any] = ["screenName": screenName,
                                     "desc" : description]
        
        ref.child("users").child("\(currentUserID)").updateChildValues(post)
        
    }
    
    
    @IBAction func editPictureButton(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        
        
    }
    

    
    func dismissImagePicker() {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(_ image: UIImage) {
        
        let ref = FIRStorage.storage().reference()
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {return}
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpeg"
        ref.child("\(currentUser?.email)-\(createTimeStamp()).jpeg").put(imageData, metadata: metaData) { (meta, error) in
            
            if let downloadPath = meta?.downloadURL()?.absoluteString {
                //save to firebase database
                self.saveImagePath(downloadPath)
                
                print("")
            }
            
        }
        
        
    }
    
    func createTimeStamp() -> String {
        
        let currentDate = NSDate()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd HH:mm"
        let timeCreated = dateFormatter.string(from: currentDate as Date)
        
        return timeCreated
        
    }
    
    func saveImagePath(_ path: String) {
        
        let profileValue : [String: Any] = ["imageURL": path]
        
        ref.child("users").child(currentUserID).updateChildValues(profileValue)
    }
}


extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        defer {
            dismissImagePicker()
        }
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        //display / store
        uploadImage(image)
        
    }
    
    func uniqueFileForUser(_ name: String) -> String {
        let currentDate = Date()
        return "\(name)_\(currentDate.timeIntervalSince1970).jpeg"
    }
    
    
}

    
    

