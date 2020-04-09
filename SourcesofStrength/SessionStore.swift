//
//  SessionStore.swift
//  SourcesofStrength
//
//  Created by Greg Schloemer on 4/7/20.
//  Copyright © 2020 Berea Community Schools. All rights reserved.
//

import SwiftUI
import Combine
import Firebase

class SessionStore: ObservableObject {
    var didChange = PassthroughSubject<SessionStore, Never>()
    @Published var user: User? { didSet { self.didChange.send(self)}}
    var handle: AuthStateDidChangeListenerHandle?
    
    func listen () {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                print("Got user: \(user)")
                self.user = User(
                    uid: user.uid,
                    displayName: user.displayName,
                    email: user.email
                )
            } else {
                self.user = nil
            }
        }
    }
    
    func signUp(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
    ) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    func signIn(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
    ){
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func signOut() -> Bool{
        do {
            try Auth.auth().signOut()
            self.user = nil
            return true
        } catch {
            print("An error occured while signing out")
            return false
        }
    }
    
    
}
