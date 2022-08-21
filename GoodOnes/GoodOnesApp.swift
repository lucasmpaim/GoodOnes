//
//  GoodOnesApp.swift
//  GoodOnes
//
//  Created by Lucas Paim on 18/08/22.
//

import SwiftUI

@main
struct GoodOnesApp: App {
    
    @ObservedObject var mainCoordinator: MainCoordinator = .init()
    
    init() {
        mainCoordinator.start()
    }
    
    var body: some Scene {
        WindowGroup {
            mainCoordinator.currentRoute
        }
    }

}
