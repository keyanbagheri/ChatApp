//
//  ImageViewController.swift
//  ChatApp
//
//  Created by bitbender on 4/12/17.
//  Copyright © 2017 Key + Max. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    var currentMessage : Message = Message()

    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let messageURL = currentMessage.imageURL
        imageView.loadImageUsingCacheWithUrlString(urlString: messageURL)
        labelView.text = currentMessage.userEmail
        
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

}
