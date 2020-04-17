//
//  ActivityTabView.swift
//  SourcesofStrength
//
//  Created by Greg Schloemer on 4/9/20.
//  Copyright © 2020 Berea Community Schools. All rights reserved.
//

import SwiftUI

struct ActivityTabView: View {
    
    @ObservedObject var activityListener = ActivityListener()
    
    var source: SourceData
    
    
    var body: some View {
        List{
            ForEach(self.activityListener.activities, id:\.id){ activity in
                Group{
                    if(activity.source.rawValue == self.source.name){
                        NavigationLink(destination: ActivityDetail(activity: activity)){
                            ActivityRow(activity: activity)
                        }
                    }
                }
            }
        }.navigationBarTitle(Text(source.readableName).foregroundColor(source.color), displayMode: .large)
    }
}

//struct ActivityTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityTabView()
//    }
//}
