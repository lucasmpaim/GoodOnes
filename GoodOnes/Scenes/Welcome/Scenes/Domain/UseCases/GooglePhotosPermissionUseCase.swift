//
//  GooglePhotosPermissionUseCase.swift
//  GoodOnes
//
//  Created by Lucas Paim on 22/08/22.
//

import Foundation
import Combine
import GPhotos

enum GPhotosPermissionError: Error {
    case denied
}

protocol GPhotosPermissionUseCase {
    func askPermission() -> AnyPublisher<Void, GPhotosPermissionError>
}

final class GPhotosPermissionUseCaseImpl : GPhotosPermissionUseCase {
    func askPermission() -> AnyPublisher<Void, GPhotosPermissionError> {
        return Future { promise in
            GPhotos.authorize(with: [.openId, .readDevData, .readOnly]) { success, error in
                guard error == nil else {
                    print(error ?? "")
                    promise(.failure(.denied))
                    return
                }
                promise(.success(()))
            }
        }.eraseToAnyPublisher()
    }
}

