//
//  Activity.swift
//  SourcesofStrength
//
//  Created by Greg Schloemer on 4/8/20.
//  Copyright © 2020 Berea Community Schools. All rights reserved.
//

import Foundation
import SwiftUI

enum Source: String, CaseIterable, Codable, Hashable{
    
    case familySupport
    case positiveFriends
    case mentors
    case healthyActivities
    case generosity
    case spirituality
    case medicalAccess
    case mentalHealth
    
}

public struct SourceData: Hashable{
    var name:String
    var readableName:String
    var color:Color
    var goalValue: CGFloat
}

public let sourcesArray: [SourceData] = [SourceData(name: kFAMILYSUPPORT, readableName: "Family Support", color: Color.orange, goalValue: kFAMILYSUPPORT_GOALVAL),
                                         SourceData(name: kPOSITIVEFRIENDS, readableName: "Positive Friends", color: .yellow, goalValue: kPOSITIVEFRIENDS_GOALVAL),
                                         SourceData(name: kMENTORS, readableName: "Mentors", color:.green, goalValue: kMENTORS_GOALVAL),
                                         SourceData(name: kHEALTHYACTIVITIES, readableName: "Healthy Activities", color: .purple, goalValue: kHEALTHYACTIVITIES_GOALVAL),
                                         SourceData(name: kGENEROSITY, readableName: "Generosity", color:.gray, goalValue: kGENEROSITY_GOALVAL),
                                         SourceData(name:kSPIRITUALITY, readableName: "Spirituality", color:.pink, goalValue: kSPIRITUALITY_GOALVAL),
                                         SourceData(name:kMEDICALACCESS, readableName: "Medical Access", color:.blue, goalValue: kMEDICALACCESS_GOALVAL),
                                         SourceData(name:kMENTALHEALTH, readableName: "Mental Health", color:.red, goalValue: kMENTALHEALTH_GOALVAL)]

struct Activity: Identifiable, Hashable{
    
    var id: String
    var title: String
    var source: Source
    var description: String
    var points: Int
    
}

func activityDictionaryFrom(activity: Activity) -> [String: Any] {
    return NSDictionary(objects: [activity.id,
                                  activity.title,
                                  activity.source.rawValue,
                                  activity.description,
                                  activity.points
                                 ],
                        forKeys: [
                            kID as NSCopying,
                            kTITLE as NSCopying,
                            kSOURCE as NSCopying,
                            kDESCRIPTION as NSCopying,
                            kPOINTS as NSCopying
    ]) as! [String:Any]
}

func createActivityList(){
    for activity in activityData{
        
        FirebaseReference(.Activity).addDocument(data: activityDictionaryFrom(activity: activity))
        
    }
}

let activityData = [
    // HEALTHY ACTIVITIES
    Activity(id: UUID().uuidString, title: "Think of 3 Things You're Thankful For", source: .healthyActivities, description: "When you wake up, think of 3 things you are thankful for before getting out of bed.", points: 5),
    Activity(id: UUID().uuidString, title: "Meditation", source: .healthyActivities, description: "Start the day with meditation!", points: 5),
    Activity(id: UUID().uuidString, title: "Take 5 Deep Breaths", source: .healthyActivities, description: "Stand outside or at a window with the sun on your face and take 5 deep breaths. Do this without any phones or music!", points: 5),
    // GENEROSITY
    Activity(id: UUID().uuidString, title: "Walk Your Dog", source: .generosity, description: "Walk your dog outside!", points: 5),
    Activity(id: UUID().uuidString, title: "Clean a Section of Your House", source: .generosity, description: "Clean a section of your room or house. Folding laundry, wiping, counters, it all helps!", points: 5),
    Activity(id: UUID().uuidString, title: "Ask Your Parents: How Can I Help?", source: .generosity, description: "Ask your parents how you can help them today.", points: 5),
    //SPIRITUALITY
    Activity(id: UUID().uuidString, title: "Watch Sunrise", source: .spirituality, description: "Watch the sunrise from your window or yard.", points: 5),
    Activity(id: UUID().uuidString, title: "Write Down your Dreams", source: .spirituality, description: "Write down your dreams when you wake up!", points: 5),
    Activity(id: UUID().uuidString, title: "Practice Journaling for 30 mins", source: .spirituality, description: "Practice journaling for a half hour when you wake up", points: 5),
    //MEDICAL ACCESS
    Activity(id: UUID().uuidString, title: "Wash Your Hands to \'Love on Top\'", source: .medicalAccess, description: "Wash your hands to \"Love on Top\" by Beyonce", points: 5),
    Activity(id: UUID().uuidString, title: "Drink Water", source: .medicalAccess, description: "Drink water to start your day strong!", points: 5),
    Activity(id: UUID().uuidString, title: "Spa Day at Home", source: .medicalAccess, description: "Spa day! Take the time to comb your hair, take a bath, and make a homemade face mask.", points: 5),
    //MENTAL HEALTH
    Activity(id: UUID().uuidString, title: "Think of 3 Things You're Excited For", source: .mentalHealth, description: "Wake up and tell yourself 3 things you are excited about for today.", points: 5),
    Activity(id: UUID().uuidString, title: "Make Your Bed", source:.mentalHealth, description: "Help start your day strong by making your bed and changing into a favorite outfit.", points: 5),
    Activity(id: UUID().uuidString, title: "Make a List of Goals for Today", source: .mentalHealth, description: "Create a list of goals for what you can accomplish each day! Give yourself a high five, a pat on the back, or a verbal \"well done\" for each thing you accomplish throughout the day.", points: 5)
]





struct Activity_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
