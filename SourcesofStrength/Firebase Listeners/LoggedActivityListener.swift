//
//  LoggedActivityListener.swift
//  SourcesofStrength
//
//  Created by Greg Schloemer on 4/9/20.
//  Copyright © 2020 Berea Community Schools. All rights reserved.
//

import Foundation
import Firebase

class LoggedActivityListener: ObservableObject{
    
    @Published var loggedActivities: [LoggedActivity]! = []
            
    init(){
        downloadLoggedActivities()
    }
    
    func downloadLoggedActivities(){
//        let formatter = DateFormatter()
//        formatter.dateFormat = kFORMATDATE
//
//        let goalWindow = formatter.string(from: week.startOfWeek ?? Date())
        
        FirebaseReference(.LoggedActivity).whereField(kOWNERID, isEqualTo: Auth.auth().currentUser!.uid).getDocuments{ (snapshot, error) in
            
            guard let snapshot = snapshot else{
                return
            }
            
            if (!snapshot.isEmpty){
                
                for snapshot in snapshot.documents{
                    let loggedActivityData = snapshot.data()
                    
                    self.loggedActivities = []
                    getActivitiesFromFirestore(withId: loggedActivityData[kACTIVITYID] as? String ?? "") { (activity) in
                        
                        let loggedActivity = LoggedActivity()
                        loggedActivity.id = loggedActivityData[kID] as? String ?? UUID().uuidString
                        loggedActivity.activity = activity
                        loggedActivity.ownerId = loggedActivityData[kID] as? String ?? "unknown"
                        loggedActivity.completedOn = loggedActivityData[kCREATEDON] as? String ?? "00-00-0000"
                        loggedActivity.goalWeek = loggedActivityData[kGOALWEEK] as? String ?? "00-00-0000"
                        self.loggedActivities.append(loggedActivity)
                    }
                    
                }
                
                
            }
            
        }
    }
    
}

func getActivitiesFromFirestore(withId: String, completion: @escaping (_ activity: Activity) -> Void){
    
    if withId == "" {
        return
    }
    
    FirebaseReference(.Activity).whereField(kID, isEqualTo: withId).getDocuments { (snapshot, error) in
        guard let snapshot = snapshot else { return }
        
        if (!snapshot.isEmpty){
            
            let activityData = snapshot.documents.first!
            
            completion(Activity(id: activityData[kID] as? String ?? UUID().uuidString, title: activityData[kTITLE] as? String ?? "unknown", source: Source(rawValue: activityData[kSOURCE] as? String ?? "mentalHealth") ?? .mentalHealth, description: activityData[kDESCRIPTION] as? String ?? "Unknown", points: activityData[kPOINTS] as? Int ?? 0))
        } else {
            print("no activity found")
            completion(Activity(id: "", title: "unknown", source: .mentors, description: "", points: 0))
        }
        
    }
    
}
