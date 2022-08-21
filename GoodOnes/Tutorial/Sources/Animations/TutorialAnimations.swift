//
//  TutorialAnimations.swift
//  GoodOnes
//
//  Created by Lucas Paim on 20/08/22.
//

import Foundation
import Lottie

enum TutorialAnimations {
    case travelingCamera, shibaRelax, imageScanning, designDrawing
}

extension TutorialAnimations: LottieAnimationDescribes {
    var name: String {
        switch self {
        case .travelingCamera: return "traveling-camera"
        case .shibaRelax:      return "shiba-relax"
        case .imageScanning:   return "image-scanning"
        case .designDrawing:   return "design-drawing"
        }
    }
    
    var loop: LottieLoopMode { .loop }
}
