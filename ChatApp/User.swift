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
    var screenName : String
    var desc : String
    var imageURL : String
    
    init( ) {
        id = ""
        email = ""
        screenName = ""
        desc = ""
        imageURL = ""
    }
    
    init(anId : String, anEmail : String, aScreenName : String, aDesc : String, anImageURL : String) {
        id = anId
        email = anEmail
        screenName = aScreenName
        desc = aDesc
        imageURL = anImageURL
    }
}
