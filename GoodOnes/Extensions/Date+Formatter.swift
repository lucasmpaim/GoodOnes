//
//  Date+Formatter.swift
//  GoodOnes
//
//  Created by Lucas Paim on 21/08/22.
//

import Foundation
import DateHelper


extension Date {
    var uiFormat: String? {
        return self.compare(.isToday) ? "Now" : self.toString(format: .custom("MMM/dd/yyyy"))
    }
    
    var fullDate: String? {
        return self.toString(format: .custom("MMM/dd/yyyy HH:mm"))
    }
}
