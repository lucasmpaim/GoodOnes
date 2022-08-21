//
//  MainCoordinator.swift
//  GoodOnes
//
//  Created by Lucas Paim on 20/08/22.
//

import Foundation
import SwiftUI


final class MainCoordinator : ObservableObject, Coordinator {
    @Published var currentRoute: AnyView = AnyView(EmptyView())
    
    private let repository: GeneralStateStorage
    init(repository: GeneralStateStorage = GeneralStateRepository()) {
        self.repository = repository
    }
    
    func start() {
        if repository[.tutorialIsDone] {
            enterOnWelcome()
        } else {
            enterOnTutorial()
        }
    }
    
    fileprivate func enterOnGrid() {
        currentRoute = AnyView {
            NavigationView {
                GridView(photos: [], coordinator: FakeGridViewCoordinable())
            }
        }
    }
    
    fileprivate func enterOnTutorial() {
        currentRoute = AnyView {
            TutorialScreen(
                viewModel: TutorialViewModel(coordinator: self)
            )
        }
    }
    
    fileprivate func enterOnWelcome() {
        currentRoute = AnyView { WelcomeScreen(viewModel: WelcomeViewModel(coorditor: self)) }
    }
    
}

extension AnyView {
    init<V: View>(@ViewBuilder _ builder: () -> V) {
        self.init(builder())
    }
}

extension MainCoordinator: TutorialCoordinable {
    func didFinishTutorial() {
        enterOnWelcome()
    }
}

extension MainCoordinator: WelcomeViewCoordinable {
    func selectGallery() {
        enterOnGrid()
    }
}

final class FakeGridViewCoordinable : GridViewCoordinable {
    func didSelectPhoto(id: Int) -> AnyView {
        AnyView(EmptyView())
    }
}
