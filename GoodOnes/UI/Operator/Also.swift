//
//  Also.swift
//  GoodOnes
//
//  Created by Lucas Paim on 20/08/22.
//

import Foundation

/**
 Also operator is a syntax sugar that apply a closure on a object
 a common use is to modify an object that has created when
 init function don't provide all properties that we want to customize
 
 ```swift
 let someView = UIView() <-< {
    $0.backgroundColor = .red
 }
 ```
 */
infix operator <-< : AssignmentPrecedence

@discardableResult public func <-< <T: Any>(left: T, right: (T) -> Void) -> T {
    right(left)
    return left
}
