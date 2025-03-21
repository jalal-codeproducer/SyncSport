//
//  OnBoardingPage.swift
//  SyncSports
//
//  Created by Mohammed Jalal Alamer on 12.03.25.
//

import SwiftUI

struct OnBoardingPage: View {
    var onBoardingContent: OnBoardingContent
    @Binding var lastPage: Bool
    var onNext: () -> Void
    @State private var animationStarted = false

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "1a2a6c"), Color(hex: "b21f1f"),
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white.opacity(0.15))
                .blur(radius: 1)
                .padding(.horizontal, 20)
                .padding(.vertical, 40)

            VStack {
                Spacer()
                LottieView(
                    animationFileName: onBoardingContent.animation,
                    loopMode: .playOnce
                )
                .frame(width: 280, height: 280)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 300, height: 300)
                )
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.5), lineWidth: 2)
                        .frame(width: 300, height: 300)
                )
                .scaleEffect(animationStarted ? 1 : 0.8)
                .opacity(animationStarted ? 1 : 0)

                Spacer()
                    .frame(height: 30)

                VStack(alignment: .leading, spacing: 15) {
                    Text(onBoardingContent.title)
                        .font(
                            .system(size: 38, weight: .heavy, design: .rounded)
                        )
                        .foregroundColor(.white)
                        .shadow(
                            color: .black.opacity(0.2), radius: 2, x: 0, y: 2)

                    Text(onBoardingContent.headline)
                        .font(
                            .system(size: 18, weight: .medium, design: .rounded)
                        )
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .shadow(
                            color: .black.opacity(0.1), radius: 1, x: 0, y: 1
                        )
                        .padding(.top, 5)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 5)
                .offset(x: animationStarted ? 0 : -50)
                .opacity(animationStarted ? 1 : 0)

                Spacer()

                HStack {
                    HStack(spacing: 8) {
                        ForEach(0..<3) { i in
                            Circle()
                                .fill(
                                    i == onBoardingContent.id.hashValue % 3
                                        ? Color.white : Color.white.opacity(0.4)
                                )
                                .frame(width: 10, height: 10)
                        }
                    }
                    .padding(.leading, 10)

                    Spacer()

                    // Next/Get Started button
                    Button(action: onNext) {
                        HStack(spacing: 8) {
                            Text(lastPage ? "Get Started" : "Next")
                                .font(
                                    .system(
                                        size: 18, weight: .bold,
                                        design: .rounded)
                                )
                                .foregroundColor(Color(hex: "1a2a6c"))

                            Image(
                                systemName: lastPage
                                    ? "checkmark.circle.fill"
                                    : "arrow.right.circle.fill"
                            )
                            .font(.system(size: 20))
                            .foregroundColor(Color(hex: "1a2a6c"))
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .fill(Color.white)
                                .shadow(
                                    color: .black.opacity(0.2), radius: 4, x: 0,
                                    y: 2)
                        )
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .offset(y: animationStarted ? 0 : 50)
                .opacity(animationStarted ? 1 : 0)
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 40)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                animationStarted = true
            }
        }
    }
}

struct OnBoardingPage_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingPage(
            onBoardingContent: OnBoardingContent(
                animation: "trophy",
                title: "Track Your Progress",
                headline:
                    "Log your runs, rides, and workouts in real time. Set goals, track stats, and see your improvement over time."
            ),
            lastPage: .constant(false),
            onNext: { print("Button Pressed!") }
        )
    }
}

struct OnBoardingContent: Identifiable {
    let id = UUID()
    let animation: String
    let title: String
    let headline: String
}
