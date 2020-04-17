//
//  Extensions.swift
//  SourcesofStrength
//
//  Created by Greg Schloemer on 4/9/20.
//  Copyright © 2020 Berea Community Schools. All rights reserved.
//

import Foundation

extension Date{
    
    var startOfWeek: Date?{
        return Calendar.autoupdatingCurrent.date(from: Calendar.autoupdatingCurrent.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
    }
    
}

extension Array {
    public subscript(index: Int, default defaultValue: @autoclosure () -> Element) -> Element {
        guard index >= 0, index < endIndex else {
            return defaultValue()
        }

        return self[index]
    }
}
