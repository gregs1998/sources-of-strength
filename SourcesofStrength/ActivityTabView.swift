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
    
    var sources: [String: [Activity]] {
        .init(
            grouping: activityListener.activities,
            by: {$0.source.rawValue}
        )
    }
    
    var body: some View {
        NavigationView{
            List{
                ForEach(sources.keys.sorted(), id:\String.self){ key in
                    Section(header: Text("\(key)")){
                        ForEach(self.sources[key]!, id:\.id){ activity in
                            NavigationLink(destination: ActivityDetail(activity: activity)){
                                ActivityRow(activity: activity)
                            }
                        }
                    }
                }
            }.navigationBarTitle("Activities")
        }
    }
}

struct ActivityTabView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityTabView()
    }
}
