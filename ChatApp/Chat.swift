//
//  Chat.swift
//  SimpleFirebase
//
//  Created by bitbender on 4/6/17.
//  Copyright © 2017 Key. All rights reserved.
//

import Foundation

class Chat {
    var id: String
    var userIds : Array<String>
    var messages : Array<Message>
    
    init( ) {
        id = ""
        userIds = [String]()
        messages = [Message]()
    }
    
    init(anId : String, userOneId: String, userTwoId: String) {
        id = anId
        userIds = [userOneId, userTwoId]
        messages = [Message]()
    }
}
