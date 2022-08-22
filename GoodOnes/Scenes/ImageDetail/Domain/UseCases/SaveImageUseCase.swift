//
//  SaveImageUseCase.swift
//  GoodOnes
//
//  Created by Lucas Paim on 22/08/22.
//

import Foundation
import UIKit

protocol SaveImageUseCase {
    func save(image: UIImage)
}

extension SaveImageUseCase {
    func merge(canvasImage: UIImage, image: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(image.size)

        let areaSize = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        image.draw(in: areaSize)

        canvasImage.draw(in: areaSize, blendMode: .normal, alpha: 1.0)

        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return mergedImage

    }
}

final class SaveImageUseCaseImpl: NSObject, SaveImageUseCase {
    func save(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        //TODO: - Handle Error
    }
}


