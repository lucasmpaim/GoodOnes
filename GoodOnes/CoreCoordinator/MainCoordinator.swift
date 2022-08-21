//
//  MainCoordinator.swift
//  GoodOnes
//
//  Created by Lucas Paim on 20/08/22.
//

import Foundation
import SwiftUI

enum AppRoute {
    case onboarding
    case grid
}

final class MainCoordinator : ObservableObject, Coordinator {
    @Published var currentRoute: AnyView = AnyView(EmptyView())
    
    private let repository: GeneralStateStorage
    init(repository: GeneralStateStorage = GeneralStateRepository()) {
        self.repository = repository
    }
    
    func start() {
        if repository[.tutorialIsDone] {
            currentRoute = AnyView { WelcomeScreen() }
        } else {
            showGrid()
        }
    }
    
    func didFinishSplashScreen() {
        showGrid()
    }
    
    fileprivate func showGrid() {
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
