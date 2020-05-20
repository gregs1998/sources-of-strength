//
//  Goals.swift
//  SourcesofStrength
//
//  Created by Greg Schloemer on 4/9/20.
//  Copyright © 2020 Berea Community Schools. All rights reserved.
//

import Foundation
import Firebase

class Goals: Identifiable, ObservableObject{
    
    var id: String!
    var ownerId: String!
    var goalWeek: String!
    @Published var familySupport: Int = 0
    @Published var positiveFriends: Int = 0
    @Published var mentors: Int = 0
    @Published var healthyActivities: Int = 0
    @Published var generosity: Int = 0
    @Published var spirituality: Int = 0
    @Published var medicalAccess: Int = 0
    @Published var mentalHealth: Int = 0
    
    func saveGoalsToFirestore(){
        FirebaseReference(.Goals).document(self.id).setData(goalsDictionaryFrom(self))
    }
    
    func clearGoal(){
        self.familySupport = 0
        self.positiveFriends = 0
        self.mentors = 0
        self.healthyActivities = 0
        self.generosity = 0
        self.spirituality = 0
        self.medicalAccess = 0
        self.mentalHealth = 0
    }
}

func goalsDictionaryFrom(_ goals: Goals) -> [String:Any]{
    NSDictionary(objects:   [goals.id as Any,
                             goals.ownerId as Any,
                             goals.goalWeek as Any,
                              goals.familySupport,
                              goals.positiveFriends,
                              goals.mentors,
                              goals.healthyActivities,
                              goals.generosity,
                              goals.spirituality,
                              goals.medicalAccess,
                              goals.mentalHealth
                            ],
                 forKeys:   [
                            kID as NSCopying,
                            kOWNERID as NSCopying,
                            kGOALWEEK as NSCopying,
                            kFAMILYSUPPORT as NSCopying,
                            kPOSITIVEFRIENDS as NSCopying,
                            kMENTORS as NSCopying,
                            kHEALTHYACTIVITIES as NSCopying,
                            kGENEROSITY as NSCopying,
                            kSPIRITUALITY as NSCopying,
                            kMEDICALACCESS as NSCopying,
                            kMENTALHEALTH as NSCopying
        ]) as! [String: Any]
}

func goalsFrom(_ dictionary: [String:Any]) -> Goals{
    let goals: Goals = Goals()
    
    goals.id = dictionary[kID] as? String
    goals.ownerId = dictionary[kOWNERID] as? String
    goals.goalWeek = dictionary[kGOALWEEK] as? String
    goals.familySupport = dictionary[kFAMILYSUPPORT] as? Int ?? 0
    goals.positiveFriends = dictionary[kPOSITIVEFRIENDS] as? Int ?? 0
    goals.mentors = dictionary[kMENTORS] as? Int ?? 0
    goals.healthyActivities = dictionary[kHEALTHYACTIVITIES] as? Int ?? 0
    goals.generosity = dictionary[kGENEROSITY] as? Int ?? 0
    goals.spirituality = dictionary[kSPIRITUALITY] as? Int ?? 0
    goals.medicalAccess = dictionary[kMEDICALACCESS] as? Int ?? 0
    goals.mentalHealth = dictionary[kMENTALHEALTH] as? Int ?? 0
    
    return goals
}
