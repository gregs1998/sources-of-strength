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
    
    @EnvironmentObject var session: SessionStore
    @ObservedObject var loggedActivityListener = LoggedActivityListener()
    
    // Goal Value State Vars
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
                    }){
                        Text("Last week")
                    }
                    Spacer()
                    Text("\(goalDate, formatter: Self.taskDateFormat)")
                    Spacer()
                    Button(action: {
                        self.goForwardWeek()
                        self.getGoal()
                    }){
                        Text("Next Week")
                    }.disabled(self.goalDate.startOfWeek == Date().startOfWeek)
                }
                .padding(.horizontal, 20)
            }
            
            Spacer()
            ScrollView(.vertical, showsIndicators: false){
                ForEach(sourcesArray, id:\.self){ source in
                    ProgressCircle(progress: self.goalPoints[source.name] ?? 0.0, goalName:source.readableName, goal:source.goalValue, color: source.color)
                }
            }
            Spacer()
        }.onAppear(perform: {
            self.getGoal()
        })
            .navigationBarItems(trailing: Button(action: {
                _ = self.session.signOut()
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
