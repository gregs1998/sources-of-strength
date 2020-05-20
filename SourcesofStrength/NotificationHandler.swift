//
//  NotificationHandler.swift
//  SourcesofStrength
//
//  Created by Greg Schloemer on 5/20/20.
//  Copyright © 2020 Berea Community Schools. All rights reserved.
//

import Foundation
import UserNotifications

    func triggerNotificationForGoalCompleted(goalWeek: String, goalName: String){
        let content = UNMutableNotificationContent()
        content.title = "You Did It!"
        content.subtitle = "You completed your \(goalName) goal for the week of \(goalWeek)"
        content.sound = UNNotificationSound.default
        
        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
