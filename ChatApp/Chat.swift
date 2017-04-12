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
    var userEmails : Array<String>
    var userScreenNames : Array<String>
    var userImages : Array<String>
    var messages : Array<Message>
    
    init( ) {
        id = ""
        userIds = [String]()
        userEmails = [String]()
        userScreenNames = [String]()
        userImages = [String]()
        messages = [Message]()
    }
    
    init(anId : String, userOneId: String, userOneEmail: String, userOneScreenName: String, userOneImageURL: String, userTwoId: String, userTwoEmail: String, userTwoScreenName: String, userTwoImageURL: String) {
        id = anId
        userIds = [userOneId, userTwoId]
        userEmails = [userOneEmail, userTwoEmail]
        userScreenNames = [userOneScreenName, userTwoScreenName]
        userImages = [userOneImageURL, userTwoImageURL]
        messages = [Message]()
    }
}
