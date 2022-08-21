//
//  FetchCameraAssetImageUseCase.swift
//  GoodOnes
//
//  Created by Lucas Paim on 21/08/22.
//

import Foundation
import Combine
import Photos
import UIKit

struct FetchCameraAssetImageRequest {
    let asset: PHAsset
    let targetSize: CGSize
}

enum ImageLoadError : Error {
    case cantLoadImage
}

protocol FetchCameraAssetImageUseCase {
    func fetchImage(_ request: FetchCameraAssetImageRequest) -> AnyPublisher<UIImage, ImageLoadError>
}

final class FetchCameraAssetImageUseCaseImpl : FetchCameraAssetImageUseCase {
    func fetchImage(_ request: FetchCameraAssetImageRequest) -> AnyPublisher<UIImage, ImageLoadError> {
        return Future { [unowned self] promise in
            PHImageManager.default().requestImage(
                for: request.asset,
                targetSize: request.targetSize,
                contentMode: .aspectFill,
                options: makeOptionsFor(request),
                resultHandler: { image, _ in
                    guard let image = image else {
                        promise(.failure(.cantLoadImage))
                        return
                    }
                    promise(.success(image))
                }
            )
        }
        .eraseToAnyPublisher()
    }
}

fileprivate extension FetchCameraAssetImageUseCaseImpl {
    func makeOptionsFor(_ request: FetchCameraAssetImageRequest) -> PHImageRequestOptions {
        let options = PHImageRequestOptions()
        options.version = .current
        options.resizeMode = .fast
        options.isNetworkAccessAllowed = true
        options.isSynchronous = false
        return options
    }
}
