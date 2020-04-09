//
//  ContentView.swift
//  SourcesofStrength
//
//  Created by Greg Schloemer on 4/7/20.
//  Copyright © 2020 Berea Community Schools. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var session: SessionStore
    
    func getUser(){
        session.listen()
    }
    
    var body: some View {
        Group{
            if(session.user != nil){
                TabView{
                    NavigationView{
                        HomeView()
                            .navigationBarTitle("Your Outlook")
                    }
                    .tabItem{
                        Image(systemName: "house")
                        Text("Home")
                    }
                    ActivityTabView()
//                        List(sources.keys.sorted(), id:\String.self, ) { key in
//                            Section(header: Text("\(key)")){
//                                ForEach(self.sources[key]!, id:\.id){ activity in
//                                    ActivityRow(sourceName: "\(key)", activity: activity)
//                                }
//                            }
//                        }
                        .tabItem{
                            Image(systemName: "book")
                            Text("Activities")
                    }
                }
            }
            else{
                AuthView()
            }
        }.onAppear(perform: getUser)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(SessionStore())
    }
}
#endif
