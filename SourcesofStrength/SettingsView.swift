//
//  SettingsView.swift
//  SourcesofStrength
//
//  Created by Greg Schloemer on 4/17/20.
//  Copyright © 2020 Berea Community Schools. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var session: SessionStore
    
    @State var displayName: String = ""
    @State var grade: String = ""
    @State var school = -1
    @State var goalMax = -1
    
    let goalMaxPickerVals: [Int] = [10,15,25]
    let schoolPickerVals = ["Berea Community Elementary", "Berea Community Middle", "Berea Community High"]
    
    var body: some View {
        
        Form{
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
            Button(action:{
                self.session.currentFUser.displayName = self.displayName
                self.session.currentFUser.grade = self.grade
                self.session.currentFUser.school = self.schoolPickerVals[self.school]
                self.session.currentFUser.goalMax = self.goalMaxPickerVals[self.goalMax]
                
                self.session.currentFUser.setFUserInFirebase()
            }){
                Text("Save User")
            }
        }.onAppear(perform:{
            self.displayName = self.session.currentFUser.displayName
            self.grade = self.session.currentFUser.grade
            // Execute retrival on first run only
            if(self.school == -1 && self.goalMax == -1){
                for i in 0 ..< self.goalMaxPickerVals.count{
                    if self.goalMaxPickerVals[i] == self.session.currentFUser.goalMax{
                        self.goalMax = i
                    }
                }
                for i in 0 ..< self.schoolPickerVals.count{
                    if self.schoolPickerVals[i] == self.session.currentFUser.school{
                        self.school = i
                    }
                }
            }
        })
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
