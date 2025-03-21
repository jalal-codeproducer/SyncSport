//
//  SplashView.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 20.03.25.
//

//
//  SplashView.swift
//  SyncSports
//
//  Created on 20.03.25
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    @State private var rotation = 0.0

    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 5)
                        .frame(width: 120, height: 120)

                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(Color.white, lineWidth: 5)
                        .frame(width: 120, height: 120)
                        .rotationEffect(Angle(degrees: rotation))
                        .onAppear {
                            withAnimation(
                                .linear(duration: 1.5).repeatForever(
                                    autoreverses: false)
                            ) {
                                rotation = 360
                            }
                        }

                    Image(systemName: "figure.run")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white)
                }
                .scaleEffect(size)
                .opacity(opacity)

                Text("SyncSports")
                    .font(
                        .system(size: 40, weight: .bold, design: .rounded)
                    )
                    .foregroundColor(.white)
                    .scaleEffect(size)
                    .opacity(opacity)

                Text("Track. Connect. Achieve.")
                    .font(
                        .system(size: 16, weight: .medium, design: .rounded)
                    )
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.top, 5)
                    .scaleEffect(size)
                    .opacity(opacity)
            }

            Spacer()

            VStack(spacing: 15) {
                ProgressView()
                    .progressViewStyle(
                        CircularProgressViewStyle(tint: .white)
                    )
                    .scaleEffect(1.5)

                Text("Loading your fitness journey...")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.bottom, 50)
        }
        .onAppear {
            withAnimation(.easeIn(duration: 1.2)) {
                self.size = 1.0
                self.opacity = 1.0
            }
        }.withAppBackground()
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
