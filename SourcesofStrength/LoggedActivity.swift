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
    var completedOn: String!
    var goalWeek: String!
    var activity = Activity(id: "", title: "", source: .mentalHealth, description: "", points: 0)
    
    func set(_ activity: Activity){
        self.activity = activity
    }
    
    func clear(){
        
        self.activity =  Activity(id: "", title: "", source: .mentalHealth, description: "", points: 0)
        
    }
    
    func loggedActivityFiltered(source: String)->LoggedActivity?{
        if(self.activity.source.rawValue == source){
            return self
        } else {
            return nil
        }
    }
    
    func saveLoggedActivityToFirestore() {
        
        FirebaseReference(.LoggedActivity).document(self.id).setData(loggedActivityDictionaryFrom(self))
        
        
    }
    
    func deleteLoggedActivity(){
        FirebaseReference(.LoggedActivity).document(self.id).delete()
        
        let currentGoalWeek = self.goalWeek
        
        FirebaseReference(.Goals).whereField(kOWNERID, isEqualTo: Auth.auth().currentUser?.uid as Any).whereField(kGOALWEEK, isEqualTo: currentGoalWeek as Any).getDocuments { (snapshot, error) in
        guard let snapshot = snapshot else { return }
            
            if (!snapshot.isEmpty){
                guard let document = snapshot.documents.first?.data() else { return }
                let documentID = document[kID] as! String
                let sourceValue = document[self.activity.source.rawValue] as! Int
                FirebaseReference(.Goals).document(documentID).updateData([self.activity.source.rawValue:sourceValue-self.activity.points])
            }
        }
    }
}


func loggedActivityDictionaryFrom(_ loggedActivity: LoggedActivity) -> [String:Any]{
    let activityId: String = loggedActivity.activity.id
    
    
    return NSDictionary(objects: [loggedActivity.id as Any,
                                  loggedActivity.ownerId as Any,
                                  loggedActivity.completedOn as Any,
                                  loggedActivity.goalWeek as Any,
                                  activityId],
                        forKeys: [kID as NSCopying,
                                  kOWNERID as NSCopying,
                                  kCREATEDON as NSCopying,
                                  kGOALWEEK as NSCopying,
                                  kACTIVITYID as NSCopying])
    as! [String: Any]
    
}
