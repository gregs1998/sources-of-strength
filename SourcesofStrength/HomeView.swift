//
//  HomeView.swift
//  SourcesofStrength
//
//  Created by Greg Schloemer on 4/8/20.
//  Copyright © 2020 Berea Community Schools. All rights reserved.
//

import SwiftUI
import Combine

struct HomeView: View {
    
    @EnvironmentObject var session: SessionStore

    @State var presentingAddView = false
    
    var body: some View {
        NavigationView{
            VStack{
                Text("Hello, \(session.user?.displayName ?? "unknown")")
                Button(action: {
                    _ = self.session.signOut()
                }){
                    Text("Sign out")
                }
            }
        }.onAppear()
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(loggedActivityStore: LoggedActivityStore())
//    }
//}
