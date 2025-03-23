//
//  ContentView.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 02.03.25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var trackManager: TrackManager
    @StateObject private var authViewModel = DependencyInjection.shared
        .provideAuthViewModel()
    var challengeViewModel = DependencyInjection.shared
        .provideDashboardViewModel()

    @State private var selectedIndex: Int = 0
    @State private var isRegistering = false
    @State private var isAuthenticated = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some View {
        NavigationStack {
            if authViewModel.showSplash {
                SplashView()
            } else {
                if !hasSeenOnboarding {
                    OnBoardingView()
                } else {
                    if authViewModel.isLoggedIn {
                        TabView(selection: $selectedIndex) {
                            NavigationStack {
                                Dashboard()
                            }
                            .tabItem {
                                Label(
                                    "Dashboard",
                                    systemImage: selectedIndex == 0
                                        ? "flag.checkered.circle.fill"
                                        : "flag.checkered.circle")
                            }
                            .tag(0)
                            
                            

                            NavigationStack {
                                ProfileView()
                            }
                            .tabItem {
                                Label(
                                    "Profiles",
                                    systemImage: selectedIndex == 1
                                        ? "person.crop.circle.fill"
                                        : "person.crop.circle")
                            }
                            .tag(1)                                            
                        }
                        .onAppear {
                            let appearance = UITabBarAppearance()
                            appearance.backgroundEffect = UIBlurEffect(
                                style: .systemUltraThinMaterial)
                            appearance.backgroundColor = UIColor.black
                                .withAlphaComponent(0.6)

                            let tabBarItemAppearance = UITabBarItemAppearance()
                            tabBarItemAppearance.normal.iconColor = UIColor
                                .white.withAlphaComponent(0.6)
                            tabBarItemAppearance.normal.titleTextAttributes = [
                                .foregroundColor: UIColor.white
                                    .withAlphaComponent(0.6)
                            ]
                            tabBarItemAppearance.selected.iconColor =
                                UIColor.white
                            tabBarItemAppearance.selected.titleTextAttributes =
                                [.foregroundColor: UIColor.white]

                            appearance.stackedLayoutAppearance =
                                tabBarItemAppearance
                            appearance.inlineLayoutAppearance =
                                tabBarItemAppearance
                            appearance.compactInlineLayoutAppearance =
                                tabBarItemAppearance

                            UITabBar.appearance().standardAppearance =
                                appearance
                            UITabBar.appearance().scrollEdgeAppearance =
                                appearance
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(TrackManager())
    }
}
