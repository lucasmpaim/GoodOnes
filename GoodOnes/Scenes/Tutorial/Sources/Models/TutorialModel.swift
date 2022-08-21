//
//  TutorialModel.swift
//  GoodOnes
//
//  Created by Lucas Paim on 20/08/22.
//

import Foundation

struct TutorialScreenModel {
    let animation: LottieAnimationDescribes
    let title: String
    let description: String
}

extension TutorialScreenModel: Identifiable {
    var id: Int {
        self.hashValue
    }
}

extension TutorialScreenModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(animation.name)
        hasher.combine(description)
    }
}

extension TutorialScreenModel: Equatable {
    static func == (lhs: TutorialScreenModel, rhs: TutorialScreenModel) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
