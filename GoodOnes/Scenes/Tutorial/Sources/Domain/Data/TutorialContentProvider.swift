//
//  TutorialContentProvider.swift
//  GoodOnes
//
//  Created by Lucas Paim on 20/08/22.
//

import Foundation

protocol TutorialContentProvidable {
    var content: [TutorialScreenModel] { get }
}

final class TutorialContentProvider: TutorialContentProvidable {
    var content: [TutorialScreenModel] = [
        .init(
            animation: TutorialAnimations.travelingCamera,
            title: "Take your photos!",
            description: "Take how many photos you want and your app can select the best ones for you!"
        ),
        .init(
            animation: TutorialAnimations.designDrawing,
            title: "Customize your photos!",
            description: "Draw inside your photos and make your art!"
        ),
        .init(
            animation: TutorialAnimations.imageScanning,
            title: "Our bots will analyse your photo!",
            description: "Don't worry your photos will never leave your phone!"
        ),
        .init(
            animation: TutorialAnimations.shibaRelax,
            title: "Relax!",
            description: "Enjoy our product, thanks for give us a chance!"
        ),
    ]
}
