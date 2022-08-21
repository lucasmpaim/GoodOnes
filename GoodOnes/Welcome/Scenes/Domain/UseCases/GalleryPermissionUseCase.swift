//
//  GalleryPermissionUseCase.swift
//  GoodOnes
//
//  Created by Lucas Paim on 20/08/22.
//

import Foundation
import Combine
import Photos

enum GalleryPermissionError: Error {
    case denied
}

protocol GalleryPermissionUseCase {
    func askPermission() -> AnyPublisher<Void, GalleryPermissionError>
}

final class GalleryPermissionUseCaseImpl : GalleryPermissionUseCase {
    func askPermission() -> AnyPublisher<Void, GalleryPermissionError> {
        let authorization = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        guard authorization != .denied else {
            return Fail(error: .denied).eraseToAnyPublisher()
        }
        
        return Future { promise in
            Task {
                let permission = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
                permission != .denied ? promise(.success(())) : promise(.failure(.denied))
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
