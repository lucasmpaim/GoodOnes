//
//  CameraRollCoordinator.swift
//  GoodOnes
//
//  Created by Lucas Paim on 21/08/22.
//

import Foundation
import SwiftUI
import Combine

final class CameraRollCoordinator : ObservableObject, Coordinator {
    
    public let objectWillChange = PassthroughSubject<Void, Never>()
    
    var currentRoute: AnyView = AnyView(Color.brown) {
        didSet {
            objectWillChange.send()
        }
    }

    func start() {
        currentRoute = AnyView {
            NavigationView {
                GridView(
                    viewModel: CameraRollGridViewModel(coordinator: self),
                    screenTitle: "Camera Roll"
                )
            }
        }
    }
    
    private func end() {
        objectWillChange.send(completion: .finished)
    }
    
    deinit {
        debugPrint("CameraRollCoordinator Deallocated")
    }
    
}

extension CameraRollCoordinator : GridViewCoordinable {
    func photoDetailDestination() -> AnyView {
        return AnyView { Color.accentColor }
    }
    
    func close() { self.end() }
}
