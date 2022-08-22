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
    func photoDetailDestination(
        loader: @escaping ImageDetailViewModel.ImageLoader,
        meta: [ImageDetailMeta]
    ) -> AnyView {
        return AnyView {
            ImageDetail(
                viewModel: ImageDetailViewModel(loadFullImage: loader, meta: meta)
            )
        }
    }
    
    func close() { self.end() }
}
