//
//  MainCoordinator.swift
//  GoodOnes
//
//  Created by Lucas Paim on 20/08/22.
//

import Foundation
import SwiftUI
import Combine


final class MainCoordinator : ObservableObject, Coordinator {
    @Published var currentRoute: AnyView = AnyView(EmptyView())
    
    var currentRoutePublisher: Published<AnyView>.Publisher { $currentRoute }
    
    private let repository: GeneralStateStorage
    
    private var cancellables = Set<AnyCancellable>()
    private var childCoordinators = [Coordinator]()
    
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
        let coordinator = CameraRollCoordinator()
        childCoordinators.append(coordinator)

        coordinator.objectWillChange
            .sink(receiveCompletion: { _ in
                self.childCoordinators.removeAll(where: { $0 is CameraRollCoordinator })
                self.enterOnWelcome()
            }, receiveValue: { [unowned coordinator] in
                self.currentRoute = coordinator.currentRoute
            })
            .store(in: &cancellables)
        
        coordinator.start()
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
