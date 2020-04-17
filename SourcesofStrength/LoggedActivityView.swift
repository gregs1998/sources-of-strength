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
    
    @State var goalPoints: [String:CGFloat] = [kFAMILYSUPPORT: 0.0,
                                               kPOSITIVEFRIENDS: 0.0,
                                               kMENTORS: 0.0,
                                               kHEALTHYACTIVITIES: 0.0,
                                               kGENEROSITY: 0.0,
                                               kSPIRITUALITY: 0.0,
                                               kMEDICALACCESS: 0.0,
                                               kMENTALHEALTH: 0.0]
    
    @State var goalDate: Date = Date()
    
    @State var presentingAddView = false
    
    func goBackWeek(){
        let startOfWeek = self.goalDate.startOfWeek
        self.goalDate = startOfWeek!.addingTimeInterval(kONEWEEKBACK)
        getGoal()
    }
    
    func goForwardWeek(){
        let startOfWeek = self.goalDate.startOfWeek
        self.goalDate = startOfWeek!.addingTimeInterval(kONEWEEKFORWARD)
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
    
    func getGoal(){
        let formatter = DateFormatter()
        formatter.dateFormat = kFORMATDATE
        
        let goalWindow = formatter.string(from: self.goalDate.startOfWeek ?? Date())
        
        FirebaseReference(.Goals).whereField(kOWNERID, isEqualTo: self.session.user?.uid as Any).whereField(kGOALWEEK, isEqualTo: goalWindow).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            
            if(!snapshot.isEmpty){
                for snapshot in snapshot.documents{
                    let data = snapshot.data()
                    for source in sourcesArray {
                        self.goalPoints[source.name] = data[source.name] as? CGFloat
                    }
                }
            }
                
            else{
                self.clearPoints()
            }
        }
    }
    
    func delete(at offsets:IndexSet){
        for index in offsets{
            let previousValue = Int(Float(goalPoints[loggedActivities[index].activity.source.rawValue] ?? 0.0))
            self.goalPoints[loggedActivities[index].activity.source.rawValue] = CGFloat(previousValue - loggedActivities[index].activity.points)
            self.loggedActivities[index].deleteLoggedActivity()
            self.loggedActivities.remove(at: index)

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
                                Text("\(Int(self.goalPoints[source.name] ?? 0))/\(Int(source.goalValue)) pts")
                            }
                            ForEach(self.loggedActivities, id:\.id) { loggedActivity in
                                Group{
                                    if(loggedActivity.activity.source.rawValue == source.name){
                                        LoggedActivityRow(loggedActivity: loggedActivity)
                                    }
                                }
                            }.onDelete(perform: self.delete)
                            NavigationLink(destination: ActivityTabView(source: source)){
                                Text("Add Activity").foregroundColor(source.color)
                            }
                        }
                    }
                }
            }.onAppear(perform: {
                self.getGoal()
                self.downloadLoggedActivities()
            }).navigationBarTitle(Text("Activity Log"), displayMode: .inline)
    }
        
        
        func downloadLoggedActivities(){
            self.loggedActivities = []
            let formatter = DateFormatter()
            formatter.dateFormat = kFORMATDATE
            
            let goalWindow = formatter.string(from: self.goalDate.startOfWeek!)
            
            FirebaseReference(.LoggedActivity).whereField(kOWNERID, isEqualTo: self.session.user?.uid).whereField(kGOALWEEK, isEqualTo: goalWindow).getDocuments{ (snapshot, error) in
                
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

struct LoggedActivityView_Previews: PreviewProvider {
    static var previews: some View {
        LoggedActivityView()
    }
}
