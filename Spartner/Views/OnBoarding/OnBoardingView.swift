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
                            onBoardingContent: onBoardingContent[index]
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .background(.white)
                .ignoresSafeArea()

                // Skip Button or Next Button
                HStack {
                    Spacer()

                    if currentIndex == onBoardingContent.count - 1 {
                        Button(action: {
                            hasSeenOnboarding = true
                        }) {
                            Text("Get Started")
                                .fontWeight(.bold)
                        }
                        .padding()
                    } else {
                        Button(action: {
                            currentIndex += 1
                        }) {
                            Text("Next")
                        }
                        .padding()
                    }
                }.background(.white)
            }
            .onAppear {
                if hasSeenOnboarding {
                    // Skip onboarding if already seen
                    navigateToMainScreen()
                }
            }
        }
        .onChange(of: currentIndex) { newIndex in
            // If it's the last onboarding page, show the "Get Started" button
            if newIndex == onBoardingContent.count - 1 {
                hasSeenOnboarding = true
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
