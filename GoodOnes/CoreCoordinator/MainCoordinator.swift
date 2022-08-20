//
//  MainCoordinator.swift
//  GoodOnes
//
//  Created by Lucas Paim on 20/08/22.
//

import Foundation
import SwiftUI

enum AppRoute {
    case splashScreen,
    onboarding,
    grid
}

final class MainCoordinator : ObservableObject, Coordinator {
    @Published var currentRoute: AnyView = AnyView(EmptyView())
    
    func start() {
        currentRoute = AnyView(WelcomeScreen())
    }
    
    func didFinishSplashScreen() {
        currentRoute = AnyView {
            NavigationView {
                GridView(photos: [], coordinator: FakeGridViewCoordinable())
            }
        }
    }
    
}

extension AnyView {
    init<V: View>(@ViewBuilder _ builder: () -> V) {
        self.init(builder())
    }
}

final class FakeGridViewCoordinable : GridViewCoordinable {
    func didSelectPhoto(id: Int) -> AnyView {
        AnyView(EmptyView())
    }
}
