//
//  ContentView.swift
//  SourcesofStrength
//
//  Created by Greg Schloemer on 4/7/20.
//  Copyright © 2020 Berea Community Schools. All rights reserved.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    
    @EnvironmentObject var session: SessionStore
    //    @ObservedObject var goalsListener: GoalsListener
    @State var presentModal: Bool = false
    
    func initSession(){
        session.listen{
            self.session.currentFUser.getFUserFromFirebase(uid: self.session.user?.uid ?? "ERROR"){
                if !self.session.currentFUser.onboarding{
                    self.presentModal = true
                }
            }
        }
    }
    
    var body: some View {
        Group{
            if(session.user != nil){
                TabView{
                    NavigationView{
                        HomeView()
                            .navigationBarTitle("Your Outlook")
                            .environmentObject(self.session)
                    }
                    .tabItem{
                        Image(systemName: "house")
                        Text("Home")
                    }
                    NavigationView{
                        LoggedActivityView().environmentObject(self.session)
                    }
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
                    EmptyView()
                        .tabItem{
                            Image(systemName: "person.3")
                            Text("Friends")
                    }
                    NavigationView{
                        SettingsView()
                        .navigationBarTitle("Settings")
                        }
                    .tabItem{
                        Image(systemName: "ellipsis")
                        Text("More")
                    }
                    
                }
            }
            else{
                AuthView().environmentObject(self.session)
            }
        }.onAppear(perform: {
            self.initSession()
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    print("All set!")
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        }).sheet(isPresented: $presentModal, content: {
            UserOnboardingView().environmentObject(self.session)
        })
    }
}

#if DEBUG
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(goalsListener: <#T##GoalsListener#>).environmentObject(SessionStore())
//    }
//}
#endif
