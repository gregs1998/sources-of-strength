//
//  ActivityRow.swift
//  SourcesofStrength
//
//  Created by Greg Schloemer on 4/9/20.
//  Copyright © 2020 Berea Community Schools. All rights reserved.
//

import SwiftUI

struct LoggedActivityRow: View {
    
    var loggedActivity: LoggedActivity
    
    var body: some View {
        VStack(alignment: .leading){
            HStack(alignment: .top){
                Text(loggedActivity.activity.title)
                    .fontWeight(.bold)
                Spacer()
                Text("\(loggedActivity.activity.points) pts")
            }
            .padding(.bottom, 20)
            Text(loggedActivity.completedOn)
        }
    }
}


//struct ActivityRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityRow(activity: activityData[0])
//    }
//}
