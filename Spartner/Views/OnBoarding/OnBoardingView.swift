//
//  OnBoardingView.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 12.03.25.
//

import SwiftUI

struct OnBoardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentIndex = 0

    let onBoardingContent: [OnBoardingContent] = [
        OnBoardingContent(
            animation: "statistic",
            title: "Track Your Progress",
            headline:
                "Log your runs, rides, and workouts in real time. Set goals, track stats, and see your improvement over time."),
        OnBoardingContent(
            animation: "trophy",
            title: "Compete & Connect",
            headline:
                "Challenge friends, join leaderboards, and compete in events. Stay motivated and push your limits!"),
    ]

    var body: some View {
        NavigationView {
            VStack {
                TabView(selection: $currentIndex) {
                    ForEach(0..<onBoardingContent.count, id: \.self) { index in
                        OnBoardingPage(
                            onBoardingContent: onBoardingContent[index],
                            lastPage: Binding(
                                get: { currentIndex == (onBoardingContent.count - 1) },
                                set: { _ in }
                            ),
                            onNext: {
                                if (currentIndex == onBoardingContent.count - 1){
                                    hasSeenOnboarding = true
                                } else {
                                    currentIndex += 1
                                }
                            }
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .background(.white)
                .ignoresSafeArea()

            }
            .onAppear {
                if hasSeenOnboarding {
                    // Skip onboarding if already seen
                    navigateToMainScreen()
                }
            }
        }
    }

    // Function to handle navigation when onboarding is finished
    private func navigateToMainScreen() {
        // Handle navigation to the main screen, could be a `NavigationLink` or programmatic navigation
        // Example: `NavigationLink(destination: MainView()) { ... }`
    }
}

#Preview {
    OnBoardingView()
}
