//
//  User.swift
//  SimpleFirebase
//
//  Created by bitbender on 4/6/17.
//  Copyright © 2017 Key. All rights reserved.
//

import Foundation

class User {
    var id: Int
    var email : String
    
    init( ) {
        id = 0
        email = ""
        password = ""
    }
    
    init(anId : Int, anEmail : String) {
        id = anId
        email = anEmail
        password = aPassword
    }
}
