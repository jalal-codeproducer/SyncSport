//
//  AppBackground.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 20.03.25.
//

import SwiftUI

struct AppBackground: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "1a2a6c"),
                Color(hex: "b21f1f")
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

struct BackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            AppBackground()
            content
        }
    }
}

extension View {
    func withAppBackground() -> some View {
        self.modifier(BackgroundModifier())
    }
}
