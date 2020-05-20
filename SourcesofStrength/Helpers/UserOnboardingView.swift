//
//  UserOnboardingView.swift
//  SourcesofStrength
//
//  Created by Greg Schloemer on 5/19/20.
//  Copyright © 2020 Berea Community Schools. All rights reserved.
//

import SwiftUI

struct UserOnboardingView: View {
    
    @EnvironmentObject var session: SessionStore
    @Environment(\.presentationMode) var presentationMode
    
    @State var displayName: String = ""
    @State var grade: String = ""
    @State var school = 0
    @State var goalMax = 0
    
    let goalMaxPickerVals: [Int] = [10,15,25]
    let schoolPickerVals = ["Berea Community Elementary", "Berea Community Middle", "Berea Community High"]
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button(action: {
                    self.session.currentFUser.displayName = self.displayName
                    self.session.currentFUser.grade = self.grade
                    self.session.currentFUser.school = self.schoolPickerVals[self.school]
                    self.session.currentFUser.goalMax = self.goalMaxPickerVals[self.goalMax]
                    
                    self.session.currentFUser.onboarding = true
                    self.session.currentFUser.setFUserInFirebase()
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Text("Done")
                }
            } //HStack
            HStack{
                Spacer()
                Text("Help us get to know you...")
                    .font(.largeTitle)
                Spacer()
            }
            TextField("Display Name", text: $displayName)
            TextField("Grade", text: $grade)
            Picker(selection: $school, label: Text("School")){
                ForEach(0 ..< self.schoolPickerVals.count){
                    Text(self.schoolPickerVals[$0])
                }
            }
            Picker(selection: $goalMax, label: Text("Difficulty")){
                ForEach(0 ..< self.goalMaxPickerVals.count){
                    Text("\(self.goalMaxPickerVals[$0])")
                }
            }
        }
    }
}

//struct UserOnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserOnboardingView(displayName: "", grade: "", school: "", goalMax: 0)
//    }
//}
