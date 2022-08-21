//
//  Lottie.swift
//  GoodOnes
//
//  Created by Lucas Paim on 20/08/22.
//

import Foundation
import SwiftUI
import Lottie


protocol LottieAnimationDescribes {
    var name: String { get }
    var loop: LottieLoopMode { get }
}

struct LottieView: UIViewRepresentable {
    
    let animation: Lottie.Animation
    let loop: LottieLoopMode
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero) <-< { $0.backgroundColor = .clear }
        let animationView = AnimationView() <-< {
            $0.animation = self.animation
            $0.loopMode = self.loop
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundBehavior = .pauseAndRestore
            $0.play()
        }
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: view.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
    }
}

enum SharedAnimation {
    case waiting
    case alienHypnotize
}

extension SharedAnimation : LottieAnimationDescribes {
    var name: String {
        switch self {
        case .waiting:
            return "bird-waiting"
        case .alienHypnotize:
            return "alien-hypnotize"
        }
    }
    
    var loop: LottieLoopMode {
        switch self {
        case .waiting:
            return .loop
        case .alienHypnotize:
            return .loop
        }
    }
}

extension LottieView {
    init?(animation: LottieAnimationDescribes) {
        guard let lottieAnimation = Lottie.Animation.named(animation.name) else { return nil }
        self.loop = animation.loop
        self.animation = lottieAnimation
    }
}
