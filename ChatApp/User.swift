//
//  User.swift
//  SimpleFirebase
//
//  Created by bitbender on 4/6/17.
//  Copyright © 2017 Key. All rights reserved.
//

import Foundation

class User {
    var id: String
    var email : String
    
    init( ) {
        id = ""
        email = ""
    }
    
    init(anId : String, anEmail : String) {
        id = anId
        email = anEmail
    }
}
