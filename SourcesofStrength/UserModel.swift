//
//  UserModel.swift
//
//
//  Created by Greg Schloemer on 4/7/20.
//

import Foundation

class User{
    var uid: String
    var email: String?
    var displayName: String?
    
    init(uid: String, displayName: String?, email: String?){
        self.uid = uid
        self.displayName = displayName
        self.email = email
    }
}
