//
//  ContentView.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 02.03.25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var trackManager: TrackManager
    @StateObject private var authViewModel = DependencyInjection.shared.provideAuthViewModel()
    var challengeViewModel = DependencyInjection.shared
        .provideChallengeViewModel()
    @State private var selectedIndex: Int = 0
    @State private var isRegistering = false
    @State private var isAuthenticated = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some View {
        NavigationStack {
            if !hasSeenOnboarding {
                OnBoardingView()
            } else {
                if authViewModel.isLoggedIn {
                    TabView(selection: $selectedIndex) {
                        NavigationStack {
                            Dashboard()
                        }
                        .tabItem {
                            Text("Dashboard")
                            Image(systemName: "flag.checkered.circle.fill")
                                .renderingMode(.template)
                        }
                        .tag(0)

                        NavigationStack {
                            Text("Profile view")
                        }
                        .tabItem {
                            Label(
                                "Profile",
                                systemImage: "person.crop.circle.fill")
                        }
                        .tag(1)

                    }
                } else {
                    if isRegistering {
                        RegisterView(
                            isRegistering: $isRegistering
                        )
                    } else {
                        LoginView(
                            isRegistering: $isRegistering,
                            isAuthenticated: $isAuthenticated
                        )
                    }
                }
            }
        }
    }
}
