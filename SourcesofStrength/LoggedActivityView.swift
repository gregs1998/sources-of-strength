//
//  LoggedActivityView.swift
//  SourcesofStrength
//
//  Created by Greg Schloemer on 4/17/20.
//  Copyright © 2020 Berea Community Schools. All rights reserved.
//

import SwiftUI

struct LoggedActivityView: View {
    
    @EnvironmentObject var session: SessionStore
    @State var loggedActivities: [LoggedActivity] = []
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    static var firstAppear: Bool = true
    
    @State var goalPoints: [String:Any] = [:]
    
    @State var goalDate: Date = Date()
    
    @State var presentingAddView = false
    
    @State var activities: [Activity] = []
    
    func goBackWeek(){
        let startOfWeek = self.goalDate.startOfWeek
        self.goalDate = startOfWeek!.addingTimeInterval(kONEWEEKBACK)
    }
    
    func goForwardWeek(){
        let startOfWeek = self.goalDate.startOfWeek
        self.goalDate = startOfWeek!.addingTimeInterval(kONEWEEKFORWARD)
    }
    
    func getGoal(){
        self.goalPoints = self.session.getUserGoalsFromLocalSession(goalDate: goalDate)
    }
    
    func delete(at offsets:IndexSet){
        
        let formatter = DateFormatter()
        formatter.dateFormat = kFORMATDATE
        
        let goalWeek = formatter.string(from: goalDate.startOfWeek ?? Date())
        
        for index in offsets{
            self.session.addPointsToUserGoals(goalWeek: goalWeek, source: (loggedActivities[index].activity.source.rawValue), pointsToAdd: (loggedActivities[index].activity.points * -1)){
                self.loggedActivities[index].deleteLoggedActivity()
                self.session.deleteUserLoggedActivity(loggedActivity: self.loggedActivities[index]){
                    self.loggedActivities = self.session.getUserLoggedActivitiesFromLocalSession(goalDate: self.goalDate)
                    self.getGoal()
                }
            }
        }
    }
    
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
                        self.getGoal()
                        self.downloadLoggedActivities()
                    }){
                        Text("Last week")
                    }
                    Spacer()
                    Text("\(goalDate, formatter: Self.taskDateFormat)")
                    Spacer()
                    Button(action: {
                        self.goForwardWeek()
                        self.getGoal()
                        self.downloadLoggedActivities()
                    }){
                        Text("Next Week")
                    }.disabled(self.goalDate.startOfWeek == Date().startOfWeek)
                }
                .padding(.horizontal, 20)
            }
            Form{
                ForEach(sourcesArray, id:\.self) { source in
                    Section{
                        HStack{
                            Text("\(source.readableName)").foregroundColor(source.color)
                            Spacer()
                            Text("\(Int(self.goalPoints[source.name] as? CGFloat ?? 0))/\(self.session.currentFUser.goalMax) pts")
                        }
                        ForEach(self.loggedActivities, id:\.id) { loggedActivity in
                            Group{
                                if(loggedActivity.activity.source.rawValue == source.name){
                                    LoggedActivityRow(loggedActivity: loggedActivity)
                                }
                            }
                        }.onDelete(perform: self.delete)
                        NavigationLink(destination: ActivityTabView(source: source, activities: self.activities).environmentObject(self.session)){
                            Text("Add Activity").foregroundColor(source.color)
                        }
                    }
                }
            }
        }.onAppear(perform: {
            if(self.session.activitiesForSession.isEmpty){
                print("I AM LOADING LOGGED ACTIVITIES FROM FIREBASE")
                self.session.getActivitiesFromFirebase() {
                    self.activities = self.session.getActivitiesFromLocalSession()
                    self.session.getUserLoggedActivitiesFromFirebase {
                        self.downloadLoggedActivities()
                        self.getGoal()
                    }
                }
                LoggedActivityView.self.firstAppear = false
            }
            self.getGoal()
            self.downloadLoggedActivities()
        }).navigationBarTitle(Text("Activity Log"), displayMode: .inline)
    }
    
    
    func downloadLoggedActivities(){
        self.activities = self.session.getActivitiesFromLocalSession()
        self.loggedActivities = self.session.getUserLoggedActivitiesFromLocalSession(goalDate: self.goalDate)
    }
    
    
}

struct LoggedActivityView_Previews: PreviewProvider {
    static var previews: some View {
        LoggedActivityView()
    }
}
