//
//  ImageClassificationUseCase.swift
//  GoodOnes
//
//  Created by Lucas Paim on 22/08/22.
//

import Foundation
import Combine
import Vision
import UIKit

struct ImageClassificationDetail {
    let label: String
    let confidence: String
}

enum ImageClassifyError: Error {
    case cantConvertImage, errorWhenClassifying
}

protocol ImageClassificationUseCase {
    func predict(_ image: UIImage) -> AnyPublisher<[ImageClassificationDetail], ImageClassifyError>
}

final class VisionImageClassificationUseCaseImpl : ImageClassificationUseCase {
    func predict(_ image: UIImage) -> AnyPublisher<[ImageClassificationDetail], ImageClassifyError> {
        return Future { promise in
            let request = VNClassifyImageRequest() { (request, error) in
                guard let observations = request.results as? [VNClassificationObservation] else {
                    promise(.failure(.errorWhenClassifying))
                    return
                }
                #if DEBUG
                observations.forEach {
                    print("\($0.identifier) : \($0.confidence.uiPercentage!)")
                }
                #endif
                let interestingObservations = observations.filter {
                    $0.confidence >= 0.6
                }
                promise(
                    .success(
                        interestingObservations
                            .map { ImageClassificationDetail(label: $0.identifier, confidence: $0.confidence.uiPercentage ?? "-") }
                    )
                )
            }
            
            guard let cgImage = image.cgImage else {
                promise(.failure(.cantConvertImage))
                return
            }
            let handler = VNImageRequestHandler(cgImage: cgImage)
            do {
                try handler.perform([request])
            } catch {
                promise(.failure(.errorWhenClassifying))
            }
        }.eraseToAnyPublisher()
    }
}
