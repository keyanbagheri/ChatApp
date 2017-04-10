//
//  Chat.swift
//  SimpleFirebase
//
//  Created by bitbender on 4/6/17.
//  Copyright © 2017 Key. All rights reserved.
//

import Foundation

class Chat {
    var id: Int
    var users : Array<User>
    var messages : Array<Message>
    
    init( ) {
        id = 0
        users = [User]()
        messages = [Message]()
    }
    
    init(anId : Int, userOne: User, userTwo: User) {
        id = anId
        users = [userOne, userTwo]
        messages = [Message]()
    }
}
