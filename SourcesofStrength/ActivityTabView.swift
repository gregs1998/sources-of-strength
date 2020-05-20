//
//  ActivityTabView.swift
//  SourcesofStrength
//
//  Created by Greg Schloemer on 4/9/20.
//  Copyright © 2020 Berea Community Schools. All rights reserved.
//

import SwiftUI

struct ActivityTabView: View {
    
    @EnvironmentObject var session: SessionStore
    
    @State var presentingModal = false
    @State var source: SourceData
    @State var activities: [Activity]
    @State var selectedActivity: Activity = Activity(id: "0", title: "unknown", source: .familySupport, description: "unknown", points: 0)
    
    var body: some View {
        List{
            ForEach(self.activities, id:\.id){ activity in
                Group{
                    if(activity.source.rawValue == self.source.name){
                        Button(action: {
                            self.selectedActivity = activity
                            self.presentingModal = true
                        }){
                            ActivityRow(activity: activity, source: self.source)
                        }.foregroundColor(.primary)
                    }
                }
            }
        }.navigationBarTitle(Text(source.readableName), displayMode: .large)
        .sheet(isPresented: $presentingModal, content: {
            ActivityDetail(activity: self.selectedActivity).environmentObject(self.session)
        }).onAppear(perform: {
            
        })
    }
}

//struct ActivityTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityTabView()
//    }
//}
