//
//  ActivityRow.swift
//  SourcesofStrength
//
//  Created by Greg Schloemer on 4/9/20.
//  Copyright © 2020 Berea Community Schools. All rights reserved.
//

import SwiftUI

struct ActivityRow: View {
    
    var activity: Activity
    
    var body: some View {
        VStack(alignment: .leading){
            HStack(alignment: .top){
                Text(activity.title)
                    .fontWeight(.bold)
                Spacer()
                Text("\(activity.points) pts")
            }
            .padding(.bottom, 20)
            Text(activity.description)
        }
    }
}


struct ActivityRow_Previews: PreviewProvider {
    static var previews: some View {
        ActivityRow(activity: activityData[0])
    }
}
