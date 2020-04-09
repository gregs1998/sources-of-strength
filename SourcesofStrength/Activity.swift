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
    // FAMILY SUPPORT
    Activity(id:UUID().uuidString, title:"Develop a Morning Ritual", source: .familySupport, description: "Develop a morning ritual to greet the morning and the day, and invite your family to participate!", points: 5),
    Activity(id: UUID().uuidString, title: "Make Breakfast or Morning Drink", source: .familySupport, description: "Make someone in your household breakfast in bed or prepare their favorite morning drink (tea, coffee, hot chocolate, juice, etc.).", points: 5),
    Activity(id: UUID().uuidString, title: "Try Eggs Different Ways", source: .familySupport, description: "Make breakfast for your family or roomates by making eggs several different ways: sunny side up, scrambled, over easy, poached...", points: 5),
    
    //POSITIVE FRIENDS
    Activity(id: UUID().uuidString, title: "Send Pic of Morning Coffee to 3 Friends", source: .positiveFriends, description: "Text 3 friends a picture of your morning cup of coffee.", points: 5),
    Activity(id: UUID().uuidString, title: "Invite a Friend to LongWalks", source: .positiveFriends, description: "Invite friends to download the LongWalks app for a guided group journal entry to keep in touch with how you're doing mentally and emotionally.", points: 5),
    Activity(id: UUID().uuidString, title: "Learn Yoga with Friends", source: .positiveFriends, description: "Learn a few moves and lead a yoga or workout class for friends via FaceTime, Zoom, or Instagram Live.", points: 5),
    
    //MENTORS
    Activity(id: UUID().uuidString, title: "Send a Mentor a Fun Article or Picture", source: .mentors, description: "Send a mentor a baby animal video or an article on a topic you know they enjoy! Remind them to take care of themselves as well.", points: 5),
    Activity(id: UUID().uuidString, title: "Send a Thank-You Note to Someone Who Helped", source: .mentors, description: "Reflect on someone who once provided you tough feedback that challenged you to become a better person. Send them a thank you note on LinkedIn, Facebook, or e-mail to let them know the positive impact they had on you.", points: 5),
    Activity(id: UUID().uuidString, title: "Be a Mentor - Build a Pillow Fort", source: .mentors, description: "Be a mentor to a younger family member by making a pillow fort with them.", points: 5)
    
]




