//
//  LoggedActivity.swift
//  SourcesofStrength
//
//  Created by Greg Schloemer on 4/9/20.
//  Copyright © 2020 Berea Community Schools. All rights reserved.
//

import Foundation
import Firebase

class LoggedActivity: Identifiable{
    
    var id: String!
    var ownerId: String!
    var activity = Activity(id: "", title: "", source: .mentalHealth, description: "", points: 0)
    
    func set(_ activity: Activity){
        self.activity = activity
    }
    
    func clear(){
        
        self.activity =  Activity(id: "", title: "", source: .mentalHealth, description: "", points: 0)
        
    }
    
    func saveLoggedActivityToFirestore() {
        FirebaseReference(.LoggedActivity).document(self.id).setData(loggedActivityDictionaryFrom(self))
        
    }
    
    
}


func loggedActivityDictionaryFrom(_ loggedActivity: LoggedActivity) -> [String:Any]{
    let activityId: String = loggedActivity.activity.id
    
    
    return NSDictionary(objects: [loggedActivity.id,
                                  loggedActivity.ownerId,
                                  activityId],
                        forKeys: [kID as NSCopying,
                                  kOWNERID as NSCopying,
                                  kACTIVITYID as NSCopying])
    as! [String: Any]
    
}
