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
            #if DEBUG
            NavigationView {
                ImageDetail(
                    meta: [
                        .init(title: "teste", description: "teste"),
                        .init(title: "teste", description: "teste")
                    ],
                    state: .idle(UIImage(systemName: "square.and.arrow.down.fill")!)
                )
            }
            #else
            mainCoordinator.currentRoute
            #endif
        }
    }

}
