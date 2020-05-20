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
    
    @Published var currentFUser: FUser = FUser()
    @Published var goalsForUser: [Goals] = []
    @Published var loggedActivitiesForUser: [LoggedActivity] = []
    @Published var activitiesForSession: [Activity] = []
    
    var handle: AuthStateDidChangeListenerHandle?
    
    func listen (completion: @escaping ()->Void) {
        print("ran listen")
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                print("Got user: \(user)")
                self.user = User(
                    uid: user.uid,
                    displayName: user.displayName,
                    email: user.email
                )
                completion()
            } else {
                self.user = nil
                completion()
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
            self.loggedActivitiesForUser = []
            self.goalsForUser = []
            self.activitiesForSession = []
            self.currentFUser = FUser()
            return true
        } catch {
            print("An error occured while signing out")
            return false
        }
    }
    
    func getUserGoalsFromFirebase(completion: @escaping () -> Void) {
        
        if(self.user != nil){
            
            print("GOT USER GOALS FROM FIREBASE")
            
            self.goalsForUser = []
            
            FirebaseReference(.Goals).whereField(kOWNERID, isEqualTo: self.user?.uid).getDocuments { (snapshot, error) in
                guard let snapshot = snapshot else { return }
                
                if(!snapshot.isEmpty){
                    for snapshot in snapshot.documents{
                        let data = snapshot.data()
                        let goal = Goals()
                        goal.goalWeek = data[kGOALWEEK] as? String
                        goal.familySupport = data[kFAMILYSUPPORT] as! Int
                        goal.generosity = data[kGENEROSITY] as! Int
                        goal.healthyActivities = data[kHEALTHYACTIVITIES] as! Int
                        goal.medicalAccess = data[kMEDICALACCESS] as! Int
                        goal.mentalHealth = data[kMENTALHEALTH] as! Int
                        goal.mentors = data[kMENTORS] as! Int
                        goal.positiveFriends = data[kPOSITIVEFRIENDS] as! Int
                        goal.spirituality = data[kSPIRITUALITY] as! Int
                        goal.ownerId = data[kOWNERID] as? String
                        goal.id = data[kID] as? String
                        
                        self.goalsForUser.append(goal)
                    }
                    completion()
                }
            }
        }
    }
    
    func getUserGoalsFromLocalSession(goalDate: Date) -> [String:Any]{
        
        let formatter = DateFormatter()
        formatter.dateFormat = kFORMATDATE
        
        let goalWeek = formatter.string(from: goalDate.startOfWeek ?? Date())
        
        for goal in self.goalsForUser{
            if(goal.goalWeek == goalWeek){
                return goalsDictionaryFrom(goal)
            }
        }
        
        return [:]
    }
    
    func addPointsToUserGoals(goalWeek: String, source: String, pointsToAdd: Int, completion: @escaping ()->Void){
        
        for goal in self.goalsForUser{
            if(goal.goalWeek == goalWeek){
                let goalsDictionary = goalsDictionaryFrom(goal)
                let mutableGoalsDictionary = (goalsDictionary as NSDictionary).mutableCopy() as! NSMutableDictionary
                let userGoalPoints = mutableGoalsDictionary[source] as? Int ?? 0
                mutableGoalsDictionary[source] = userGoalPoints + pointsToAdd
                
                if mutableGoalsDictionary[source] as! Int >= self.currentFUser.goalMax{
                    triggerNotificationForGoalCompleted(goalWeek: goalWeek, goalName: source)
                }
                
                // Write new goals back to Firebase
                FirebaseReference(.Goals).document(goal.id as! String).setData(mutableGoalsDictionary as! [String:Any])
                getUserGoalsFromFirebase{
                    completion()
                }
                return
            }
        }
        
        // CASE WHERE GOALS DONT ALREADY EXIST
        let newGoal = Goals()
        newGoal.id = UUID().uuidString
        newGoal.goalWeek = goalWeek
        newGoal.ownerId = self.user?.uid
        let goalsDictionary = goalsDictionaryFrom(newGoal)
        let mutableGoalsDictionary = (goalsDictionary as NSDictionary).mutableCopy() as! NSMutableDictionary
        let userGoalPoints = mutableGoalsDictionary[source] as? Int ?? 0
        mutableGoalsDictionary[source] = userGoalPoints + pointsToAdd
        
        if mutableGoalsDictionary[source] as! Int >= self.currentFUser.goalMax{
            triggerNotificationForGoalCompleted(goalWeek: goalWeek, goalName: source)
        }
        
        // Write new goals back to Firebase
        FirebaseReference(.Goals).document(newGoal.id as! String).setData(mutableGoalsDictionary as! [String:Any])
        getUserGoalsFromFirebase {
            completion()
        }
        
    }
    
    func getActivitiesFromFirebase(completion: @escaping ()-> Void){
        
        self.activitiesForSession = []
        
        FirebaseReference(.Activity).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            
            if !snapshot.isEmpty{
                
                for snapshot in snapshot.documents{
                    let data = snapshot.data()
                    var activity = Activity(id: "", title: "Unknown", source: .mentalHealth, description: "Unknown", points: 0)
                    activity.id = data[kID] as! String
                    activity.title = data[kTITLE] as! String
                    activity.source = Source(rawValue: data[kSOURCE] as! String) ?? Source.mentalHealth
                    activity.description = data[kDESCRIPTION] as! String
                    activity.points = data[kPOINTS] as? Int ?? 0
                    self.activitiesForSession.append(activity)
                }
                completion()
            }
        }
    }
    
    func getActivitiesFromLocalSession() -> [Activity]{
        return self.activitiesForSession
    }
    
    func getActivityFromLocalSessionById(id: String)->Activity{
        for activity in self.activitiesForSession{
            if(activity.id == id){
                return activity
            }
        }
        return Activity(id: "", title: "", source: .mentalHealth, description: "", points: 0)
    }
    
    func getUserLoggedActivitiesFromFirebase(completion: @escaping ()-> Void){
        
        print("LOADING FROM FIREBASE")
        
        self.loggedActivitiesForUser = []
        
        FirebaseReference(.LoggedActivity).whereField(kOWNERID, isEqualTo: self.user?.uid).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            
            if !snapshot.isEmpty{
                
                for snapshot in snapshot.documents{
                    let data = snapshot.data()
                    var loggedActivity = LoggedActivity()
                    loggedActivity.completedOn = data[kCREATEDON] as? String ?? "00-00-0000"
                    loggedActivity.id = data[kID] as? String ?? "00"
                    loggedActivity.ownerId = data[kOWNERID] as? String ?? "OWNERID"
                    loggedActivity.activity = self.getActivityFromLocalSessionById(id: data[kACTIVITYID] as? String ?? "")
                    loggedActivity.goalWeek = data[kGOALWEEK] as? String ?? "00-00-0000"
                    self.loggedActivitiesForUser.append(loggedActivity)
                }
                completion()
            }
        }
    }
    
    func getUserLoggedActivitiesFromLocalSession(goalDate: Date) -> [LoggedActivity]{
        
        let formatter = DateFormatter()
        formatter.dateFormat = kFORMATDATE
        
        let goalWeek = formatter.string(from: goalDate.startOfWeek ?? Date())
        
        var loggedActivities: [LoggedActivity] = []
        
        for loggedActivity in self.loggedActivitiesForUser{
            if loggedActivity.goalWeek == goalWeek{
                loggedActivities.append(loggedActivity)
            }
        }
        
        return loggedActivities
    }
    
    func addUserLoggedActivity(loggedActivity: LoggedActivity){
        FirebaseReference(.LoggedActivity).document(loggedActivity.id as String).setData(loggedActivityDictionaryFrom(loggedActivity))
        getUserLoggedActivitiesFromFirebase(completion: {
            return
        })
    }
    
    func deleteUserLoggedActivity(loggedActivity: LoggedActivity, completion: @escaping ()-> Void){
        FirebaseReference(.LoggedActivity).document(loggedActivity.id).delete()
        getUserLoggedActivitiesFromFirebase{
            completion()
        }
    }
    
    
}
