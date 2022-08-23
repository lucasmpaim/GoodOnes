//
//  GPhotosCoordinator.swift
//  GoodOnes
//
//  Created by Lucas Paim on 22/08/22.
//

import Foundation
import SwiftUI
import Combine

final class GPhotosCoordinator : ObservableObject, Coordinator {
    
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
                    viewModel: GPhotosViewModel(coordinator: self),
                    screenTitle: "GPhotos"
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

extension GPhotosCoordinator : GridViewCoordinable {
    func photoDetailDestination(
        loader: @escaping ImageDetailViewModel.ImageLoader,
        meta: [ImageDetailMeta],
        photoId: String
    ) -> AnyView {
        return AnyView {
            ImageDetail(
                viewModel: ImageDetailViewModel(loadFullImage: loader, meta: meta, photoId: photoId)
            )
        }
    }
    
    func close() { self.end() }
}
