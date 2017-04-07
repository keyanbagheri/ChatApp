//
//  ViewController.swift
//  ChatApp
//
//  Created by bitbender on 4/7/17.
//  Copyright © 2017 Key + Max. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var user : String?

    @IBOutlet weak var nameTextField: UITextView!
    @IBAction func loginButtonTapped(_ sender: Any) {
        self.user = self.nameTextField
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

