//
//  LottieView.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 12.03.25.
//

import Lottie
import SwiftUI

struct LottieView: UIViewRepresentable {
    var animationFileName: String
    let loopMode: LottieLoopMode

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView(name: animationFileName)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.loopMode = loopMode
        animationView.play()
        animationView.contentMode = .scaleAspectFit  

        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // No updates needed
    }
}
