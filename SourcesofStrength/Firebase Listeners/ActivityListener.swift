//
//  ActivityListener.swift
//  SourcesofStrength
//
//  Created by Greg Schloemer on 4/9/20.
//  Copyright © 2020 Berea Community Schools. All rights reserved.
//

import Foundation
import Firebase

class ActivityListener: ObservableObject{
    
    @Published var activities: [Activity] = []
    
    init(){
        downloadActivities()
    }
    
    func downloadActivities(){
        FirebaseReference(.Activity).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            
            if !snapshot.isEmpty{
                
                self.activities = ActivityListener.activityFromDictionary(snapshot)
                
            }
            
        }
    }
    
    static func activityFromDictionary(_ snapshot: QuerySnapshot) -> [Activity]{
        
        var allActivities: [Activity] = []
        
        for snapshot in snapshot.documents{
            let activityData = snapshot.data()
            
            allActivities.append(Activity(id: activityData[kID] as? String ?? UUID().uuidString, title: activityData[kTITLE] as? String ?? "Unknown", source: Source(rawValue: activityData[kSOURCE] as? String ?? "mentalHealth") ?? .mentalHealth, description: activityData[kDESCRIPTION] as? String ?? "Unknown", points: activityData[kPOINTS] as? Int ?? 0))
        }
        
        return allActivities
    }
    
}
