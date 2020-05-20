////
////  GoalsListener.swift
////  SourcesofStrength
////
////  Created by Greg Schloemer on 5/12/20.
////  Copyright © 2020 Berea Community Schools. All rights reserved.
////
//
//import Foundation
//import FirebaseAuth
//
//class GoalsListener: ObservableObject{
//
//    @Published var goalPoints: [String:CGFloat] = [kFAMILYSUPPORT: 0.0,
//                                                   kPOSITIVEFRIENDS: 0.0,
//                                                   kMENTORS: 0.0,
//                                                   kHEALTHYACTIVITIES: 0.0,
//                                                   kGENEROSITY: 0.0,
//                                                   kSPIRITUALITY: 0.0,
//                                                   kMEDICALACCESS: 0.0,
//                                                   kMENTALHEALTH: 0.0]
//    @Published var allUserGoals: [Goals] = []
//    var goalDate: Date = Date()
//    var currentUser: User?
//
//    func getUserGoalsFromFirebase(){
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = kFORMATDATE
//
//        FirebaseReference(.Goals).whereField(kOWNERID, isEqualTo: self.currentUser?.uid as Any).getDocuments { (snapshot, error) in
//            guard let snapshot = snapshot else { return }
//
//            if(!snapshot.isEmpty){
//                for snapshot in snapshot.documents{
//                    let data = snapshot.data()
//                    let goal = Goals()
//                    goal.goalWeek = data[kGOALWEEK] as? String
//                    goal.familySupport = data[kFAMILYSUPPORT] as! Int
//                    goal.generosity = data[kGENEROSITY] as! Int
//                    goal.healthyActivities = data[kHEALTHYACTIVITIES] as! Int
//                    goal.medicalAccess = data[kMEDICALACCESS] as! Int
//                    goal.mentalHealth = data[kMENTALHEALTH] as! Int
//                    goal.mentors = data[kMENTORS] as! Int
//                    goal.positiveFriends = data[kPOSITIVEFRIENDS] as! Int
//                    goal.spirituality = data[kSPIRITUALITY] as! Int
//                    goal.ownerId = data[kOWNERID] as? String
//                    goal.id = data[kID] as? String
//
//                }
//            }
//        }
//    }
//
//    func setNewGoalWeek(newGoalDate: Date){
//        self.goalDate = newGoalDate
//    }
//
//    func getGoalsForGoalWeek(){
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = kFORMATDATE
//
//        let goalWindow = formatter.string(from: self.goalDate.startOfWeek ?? Date())
//
//        for goal in allUserGoals{
//            if goal.goalWeek == goalWindow{
//                var goalForWeekPoints: [String:CGFloat] = [:]
//                goalForWeekPoints[kFAMILYSUPPORT] = CGFloat(goal.familySupport)
//                goalForWeekPoints[kGENEROSITY] = CGFloat(goal.generosity)
//                goalForWeekPoints[kHEALTHYACTIVITIES] = CGFloat(goal.healthyActivities)
//                goalForWeekPoints[kMEDICALACCESS] = CGFloat(goal.medicalAccess)
//                goalForWeekPoints[kMENTORS] = CGFloat(goal.mentors)
//                goalForWeekPoints[kPOSITIVEFRIENDS] = CGFloat(goal.positiveFriends)
//                goalForWeekPoints[kSPIRITUALITY] = CGFloat(goal.spirituality)
//            }
//        }
//
//    }
//
//}
