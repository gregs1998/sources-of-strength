//
//  HomeView.swift
//  SourcesofStrength
//
//  Created by Greg Schloemer on 4/8/20.
//  Copyright © 2020 Berea Community Schools. All rights reserved.
//

import SwiftUI
import Combine
import Firebase

struct HomeView: View {
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    static var firstAppear: Bool = true
        
    @EnvironmentObject var session: SessionStore
//    @ObservedObject var userGoals: GoalsListener
//    @ObservedObject var loggedActivityListener = LoggedActivityListener()
    
//    init(userGoals: GoalsListener){
//        userGoals.currentUser = self.session.user
//        userGoals.getUserGoalsFromFirebase()
//    }
    
    // Goal Value State Vars
    @State var goalPoints: [String:Any] = [:]
    
    @State var goalDate: Date = Date()
    
    @State var presentingAddView = false
    
    func goBackWeek(){
        let startOfWeek = self.goalDate.startOfWeek
        self.goalDate = startOfWeek!.addingTimeInterval(kONEWEEKBACK)
        self.goalPoints = self.session.getUserGoalsFromLocalSession(goalDate: goalDate)
    }
    
    func goForwardWeek(){
        let startOfWeek = self.goalDate.startOfWeek
        self.goalDate = startOfWeek!.addingTimeInterval(kONEWEEKFORWARD)
        self.goalPoints = self.session.getUserGoalsFromLocalSession(goalDate: goalDate)
    }
    
    func clearPoints(){
        self.goalPoints[kFAMILYSUPPORT] = 0.0
        self.goalPoints[kPOSITIVEFRIENDS] = 0.0
        self.goalPoints[kMENTORS] = 0.0
        self.goalPoints[kHEALTHYACTIVITIES] = 0.0
        self.goalPoints[kGENEROSITY] = 0.0
        self.goalPoints[kSPIRITUALITY] = 0.0
        self.goalPoints[kMEDICALACCESS] = 0.0
        self.goalPoints[kMENTALHEALTH] = 0.0
    }
    
//    func getGoal(){
//        let formatter = DateFormatter()
//        formatter.dateFormat = kFORMATDATE
//
//        let goalWindow = formatter.string(from: self.goalDate.startOfWeek ?? Date())
//
//        FirebaseReference(.Goals).whereField(kOWNERID, isEqualTo: self.session.user?.uid as Any).whereField(kGOALWEEK, isEqualTo: goalWindow).getDocuments { (snapshot, error) in
//            guard let snapshot = snapshot else { return }
//
//            if(!snapshot.isEmpty){
//                for snapshot in snapshot.documents{
//                    let data = snapshot.data()
//                    for source in sourcesArray {
//                        self.goalPoints[source.name] = data[source.name] as? CGFloat
//                    }
//                }
//            }
//
//            else{
//                self.clearPoints()
//            }
//        }
//    }
    
    var body: some View {
        VStack{
            VStack{
                HStack{
                    Spacer()
                    Text("WEEK OF")
                        .foregroundColor(Color.black)
                        .fontWeight(.semibold)
                    Spacer()
                }
                HStack(alignment: .top){
                    Button(action: {
                        self.goBackWeek()
                    }){
                        Text("Last week")
                    }
                    Spacer()
                    Text("\(goalDate, formatter: Self.taskDateFormat)")
                    Spacer()
                    Button(action: {
                        self.goForwardWeek()
                    }){
                        Text("Next Week")
                    }.disabled(self.goalDate.startOfWeek == Date().startOfWeek)
                }
                .padding(.horizontal, 20)
            }
            
            Spacer()
            ScrollView(.vertical, showsIndicators: false){
                ForEach(sourcesArray, id:\.self){ source in
                    ProgressCircle(progress: self.goalPoints[source.name] as? CGFloat ?? 0.0, goalName:source.readableName, goal:CGFloat(self.session.currentFUser.goalMax), color: source.color)
                }
            }
            Spacer()
        }.onAppear(perform: {
//            self.getGoal()
            if(self.session.goalsForUser.isEmpty){
                self.session.getUserGoalsFromFirebase(){
                    print("READ FROM FIREBASE!!")
                    print("count = \(self.session.goalsForUser.count)")
                    self.goalPoints = self.session.getUserGoalsFromLocalSession(goalDate: self.goalDate)
                }
                HomeView.self.firstAppear = false
            } else{
                self.goalPoints = self.session.getUserGoalsFromLocalSession(goalDate: self.goalDate)
            }
            print("did it work?")
        })
            .navigationBarItems(trailing: Button(action: {
                _ = self.session.signOut()
                HomeView.firstAppear = true
                LoggedActivityView.firstAppear = true
                self.session.activitiesForSession = []
                self.session.goalsForUser = []
                self.session.loggedActivitiesForUser = []
            }){
                Text("Sign Out")
            })
    }
}


//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(loggedActivityStore: LoggedActivityStore())
//    }
//}
