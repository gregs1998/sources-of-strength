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
            Section{
                VStack(alignment: .leading){
                    Text("My Goals")
                        .font(.system(size:32))
                        .fontWeight(.bold)
                    Text("\(activity.source.rawValue)")
                        .padding(.bottom, 200)
                    Button(action:{
                        
                    }){
                        Text("Hi!")
                    }
                }
            }

            
        }
    }//End of ScrollView
}


struct ActivityDetail_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetail(activity: activityData[0])
    }
}
