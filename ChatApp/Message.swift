//
//  Message.swift
//  SimpleFirebase
//
//  Created by bitbender on 4/6/17.
//  Copyright © 2017 Key. All rights reserved.
//

import Foundation

class Message {
    var id: Int
    var userName : String
    var body : String
    var timeCreated : String
    
    init( ) {
        id = 0
        userName = ""
        body = ""
        timeCreated = ""
    }
    
    init(anId : Int, aName : String, aBody : String, aDate : String) {
        id = anId
        userName = aName
        body = aBody
        timeCreated = aDate
    }
}
