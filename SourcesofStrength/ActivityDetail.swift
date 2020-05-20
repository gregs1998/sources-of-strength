//
//  ActivityDetail.swift
//  SourcesofStrength
//
//  Created by Greg Schloemer on 4/9/20.
//  Copyright © 2020 Berea Community Schools. All rights reserved.
//

import SwiftUI

struct ActivityDetail: View {
    
    var activity: Activity
    @State private var dateCreated = Date()
    @EnvironmentObject var session: SessionStore
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form{
            Section{
                VStack(alignment: .leading){
                    Text(activity.title)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                    Text("\(activity.points) pts")
                        .padding(.bottom, 5)
                    Text(activity.description)
                        .fontWeight(.semibold)
                        .padding(.bottom, 15)
                }
                DatePicker(selection: $dateCreated, in: ...Date(), displayedComponents: .date) {
                    Text("Date Completed")
                }
            }
//            Section{
//                VStack(alignment: .leading){
//                    Text("My Goals")
//                        .font(.system(size:32))
//                        .fontWeight(.bold)
//                    //GoalView(goalWeek: $dateCreated, source: activity.source.rawValue)
//                    Text("\(activity.source.rawValue)")
//                        .padding(.bottom, 200)
//                }
//            }
            Section{
                Button(action:{
                    self.addActivityToLoggedActivity()
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Text("Add to My Log")
                }
            }
            
            
        }
    }//End of ScrollView
    
    private func addActivityToLoggedActivity(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = kFORMATDATE
        
        var loggedActivity: LoggedActivity!
        
        loggedActivity = LoggedActivity()
        loggedActivity.ownerId = self.session.user?.uid
        loggedActivity.id = UUID().uuidString
        loggedActivity.completedOn = formatter.string(from: self.dateCreated)
        loggedActivity.goalWeek = formatter.string(from: dateCreated.startOfWeek ?? Date())
        loggedActivity.set(self.activity)
        self.session.addUserLoggedActivity(loggedActivity: loggedActivity)
        self.session.addPointsToUserGoals(goalWeek: loggedActivity.goalWeek, source: loggedActivity.activity.source.rawValue, pointsToAdd: loggedActivity.activity.points){
            
        }
            
        
    }
    
    private func addActivityPointsToGoal(forWeek: String){
//        FirebaseReference(.Goals).whereField(kOWNERID, isEqualTo: self.session.user?.uid as Any).whereField(kGOALWEEK, isEqualTo: forWeek).getDocuments { (snapshot, error) in
//            guard let snapshot = snapshot else { return }
//
//            if snapshot.isEmpty{
//                let newGoals = Goals()
//                newGoals.id = UUID().uuidString
//                newGoals.goalWeek = forWeek
//                newGoals.ownerId = self.session.user?.uid
//                let newGoalsDictionary = goalsDictionaryFrom(newGoals)
//                let newGoalsMutable = (newGoalsDictionary as NSDictionary).mutableCopy() as! NSMutableDictionary
//                newGoalsMutable.setValue(self.activity.points, forKey: self.activity.source.rawValue)
//                FirebaseReference(.Goals).document(newGoals.id).setData(newGoalsMutable as! [String:Any])
//            }
//
//            else{
//
//                let userGoalsForPeriod = snapshot.documents.first!.data()
//                let userSourcePoints: Int = userGoalsForPeriod[self.activity.source.rawValue] as? Int ?? 0
//                let userGoalsForPeriodMutable = (userGoalsForPeriod as NSDictionary).mutableCopy() as! NSMutableDictionary
//                userGoalsForPeriodMutable[self.activity.source.rawValue] = (userSourcePoints+self.activity.points)
//                FirebaseReference(.Goals).document(userGoalsForPeriod[kID] as! String).setData(userGoalsForPeriodMutable as! [String:Any])
//            }
//
//        }
//
//        //        var goals: Goals!
//        //        goals = Goals()
//        //        goals.ownerId = session.user?.uid
//        //        goals.id = UUID().uuidString
//
//
//        // check if user has basket
//    }
                
    }
    
}




struct ActivityDetail_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetail(activity: activityData[0])
    }
}
