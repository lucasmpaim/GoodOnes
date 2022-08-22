//
//  Numeric+Formatter.swift
//  GoodOnes
//
//  Created by Lucas Paim on 22/08/22.
//

import Foundation

extension Numeric {
    var uiPercentage: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumIntegerDigits = 1
        formatter.maximumIntegerDigits = 3
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(for: self)
    }
}
