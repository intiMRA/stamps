//
//  LottieView.swift
//  Stamps
//
//  Created by Inti Albuquerque on 26/11/21.
//

import Foundation

import SwiftUI
import Lottie

enum LottieAnimationName: String {
    case done = "stamp-animation"
    case heart = "reward-animation"
}

struct LottieView: UIViewRepresentable {
    var name: LottieAnimationName
    let completion: (Bool) -> Void
    var loopMode: LottieLoopMode = .playOnce
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .background
        let animationView = AnimationView()
        
        animationView.animation = Animation.named(name.rawValue)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        animationView.play(completion: completion)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {}
}
