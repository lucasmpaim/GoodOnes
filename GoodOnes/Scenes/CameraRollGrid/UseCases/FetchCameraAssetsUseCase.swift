//
//  FetchCameraPhotosUseCase.swift
//  GoodOnes
//
//  Created by Lucas Paim on 21/08/22.
//

import Foundation
import Combine
import Photos


struct FetchCameraAssetsRequest {
    let type: PHAssetMediaType
    let date: Date
}

protocol FetchCameraAssetsUseCase {
    func fetchCameraPhotos(_ request: FetchCameraAssetsRequest) -> AnyPublisher<[PHAsset], Never>
}

final class FetchCameraAssetsUseCaseImpl : FetchCameraAssetsUseCase {
    func fetchCameraPhotos(_ request: FetchCameraAssetsRequest) -> AnyPublisher<[PHAsset], Never> {
        return Future { [unowned self] promise in
            let result = PHAsset.fetchAssets(with: request.type, options: self.makeOptionsFor(request))
            promise(.success(Array(_immutableCocoaArray: result)))
        }
        .eraseToAnyPublisher()
    }
}

fileprivate extension FetchCameraAssetsUseCaseImpl {
    func makeOptionsFor(_ request: FetchCameraAssetsRequest) -> PHFetchOptions {
        let options = PHFetchOptions()
        options.fetchLimit = 15
        options.includeHiddenAssets = false
        
        let sorter = [NSSortDescriptor(key: "creationDate", ascending: false)]
        options.sortDescriptors = sorter
        
        let predicate = NSPredicate(format: "creationDate < %@", request.date as NSDate)
        options.predicate = predicate
        return options
    }
}
